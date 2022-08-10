
-- =============================================================
-- Author:		ftianx
-- Create date: 2021-07-26 11:38:09.267
-- Description:	Save Lot Dispositions (Bulk Update)
--				
-- =============================================================
CREATE PROCEDURE [npsg].[SaveLotDispositions]
(
	  @userId varchar(255)
    , @lotDispositions [npsg].[IOdmLotDispositions] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dtoId INT
	DECLARE @maxDtoId INT
	DECLARE @curDtoId INT
	DECLARE @needToRerunScenario BIT
	DECLARE @scenarioId INT
	DECLARE @odmQualFilterId INT
	DECLARE @lotDispositionReasonId INT
	DECLARE @notes VARCHAR(MAX)
	DECLARE @lotDispositionActionId INT

	DECLARE @curOrigLotDispositionActionId INT

	DECLARE @odmQualFilterLotDispositionsId INT
	DECLARE @notQualifiedCatagoryId INT = (SELECT Id FROM [Callisto].[ref].[OdmQualFilterCategories] WITH (NOLOCK) WHERE [Name] = 'Non Qualified')
	DECLARE @qualifiedCatagoryId INT = (SELECT Id FROM [Callisto].[ref].[OdmQualFilterCategories] WITH (NOLOCK) WHERE [Name] = 'Qualified')
	DECLARE @modified INT = (SELECT Id FROM [ref].[OdmQualFilterStatuses] WITH (NOLOCK) WHERE [Name] = 'Modified')

	SELECT @maxDtoId = MAX(Id) FROM @lotDispositions
	SET @curDtoId = 1
	SET @needToRerunScenario = 0

	BEGIN TRAN BatchUpdate

	BEGIN TRY

		WHILE @curDtoId <= @maxDtoId
		BEGIN
			SELECT 
				@scenarioId = ScenarioId,
				@odmQualFilterId = OdmQualFilterId,
				@lotDispositionReasonId = LotDispositionReasonId,
				@notes = Notes,
				@lotDispositionActionId = LotDispositionActionId
			FROM @lotDispositions
			WHERE Id = @curDtoId

			SET @odmQualFilterLotDispositionsId = (SELECT [Id] FROM [npsg].[OdmQualFilterLotDispositions] WITH (NOLOCK) WHERE [OdmQualFilterId] = @odmQualFilterId);

			-- If non existing, insert			
			IF @odmQualFilterLotDispositionsId IS NULL
				BEGIN
					INSERT INTO [npsg].[OdmQualFilterLotDispositions]
						([ScenarioId]
						,[OdmQualFilterId]
						,[LotDispositionReasonId]
						,[Notes]
						,[LotDispositionActionId]
						,[CreatedOn]
						,[CreatedBy]
						,[UpdatedOn]
						,[UpdatedBy])
					VALUES
						(@scenarioId
						,@odmQualFilterId
						,@lotDispositionReasonId
						,@notes
						,@lotDispositionActionId
						,GETDATE()
						,@userId
						,GETDATE()
						,@userId)
				END
			ELSE
			BEGIN
				--Update related tables
				SELECT @curOrigLotDispositionActionId = [LotDispositionActionId] FROM [npsg].[OdmQualFilterLotDispositions] WITH (NOLOCK) WHERE [Id] = @odmQualFilterLotDispositionsId

				IF (@lotDispositionActionId <> @curOrigLotDispositionActionId)
				BEGIN
					SET @needToRerunScenario = 1

					IF (@lotDispositionActionId = @qualifiedCatagoryId)
					BEGIN
						--Changed to qualified below
						MERGE [npsg].[OdmQualFilterNonQualifiedMediaExceptions] AS TRG
						USING 
						(
								SELECT [ScenarioId], [DesignId], [OdmId], [SCode], [MediaIPN], [SLot]
								FROM [npsg].[OdmQualFilters]  WITH (NOLOCK) 
								WHERE [Id] = @odmQualFilterId
						) AS SRC
						ON
						(
							 TRG.[ScenarioId]		= SRC.[ScenarioId]		AND
							 TRG.[OdmId]			= SRC.[OdmId]			AND
							 TRG.[SCodeMMNumber]	= SRC.[SCode]			AND
							 TRG.[MediaIPN]			= SRC.[MediaIPN]		AND
							 TRG.[SLot]				= SRC.[SLot]			
						)
						WHEN NOT MATCHED BY TARGET THEN 
							INSERT (
									 [ScenarioId]
									,[DesignId]
									,[OdmId]
									,[SCodeMMNumber]
									,[MediaIPN]
									,[SLot])
							 VALUES
								   (SRC.[ScenarioId]
								   ,SRC.[DesignId]
								   ,SRC.[OdmId]
								   ,SRC.[SCode]
								   ,SRC.[MediaIPN]
								   ,SRC.[SLot]
								   );

						UPDATE [npsg].[OdmQualFilters]
						SET [OdmQualFilterCategoryId] = @qualifiedCatagoryId
						WHERE [Id] = @odmQualFilterId
					END
					ELSE
					BEGIN
						--Changed to non qualified below 
						DECLARE @OdmId INT,
								@Scode VARCHAR(50),
								@MediaIPN VARCHAR(100),
								@SLot VARCHAR(50)

						SELECT  @scenarioId = [ScenarioId],
								@OdmId = [OdmId],
								@Scode = [SCode],
								@MediaIPN = [MediaIPN],
								@SLot = [SLot]
						FROM [npsg].[OdmQualFilters] WITH (NOLOCK) 
						WHERE [Id] = @odmQualFilterId

						DELETE
						FROM [npsg].[OdmQualFilterNonQualifiedMediaExceptions]
						WHERE [ScenarioId] = @scenarioId
							AND [OdmId] = @OdmId
							AND [SCodeMMNumber] = @Scode
							AND [MediaIPN] = @MediaIPN
							AND [SLot] = @SLot

						UPDATE [npsg].[OdmQualFilters]
						SET [OdmQualFilterCategoryId] = @notQualifiedCatagoryId
						WHERE [Id] = @odmQualFilterId;
					END -- INNER IF
				END -- OUTTER INNER IF

				UPDATE [npsg].[OdmQualFilterLotDispositions]
				SET  [LotDispositionReasonId] = @lotDispositionReasonId
					,[Notes] = @notes
					,[LotDispositionActionId] = @lotDispositionActionId
					,[UpdatedOn] = GETDATE()
					,[UpdatedBy] = @userId
				WHERE [Id] = @odmQualFilterLotDispositionsId
			END -- OUTER IF

			SET @curDtoId = @curDtoId + 1
		END  -- WHILE

		--IF (@needToRerunScenario = 1)
		BEGIN
			UPDATE [npsg].[OdmQualFilterScenarios]
			SET [StatusId] = @modified
			WHERE [Id] = @scenarioId;
		END

		COMMIT TRAN BatchUpdate

		-- Return fresh data to the UI
		EXEC [npsg].[GetOdmQualFilterScenarioVersions] @userId, @scenarioId;
		EXEC [npsg].[GetOdmLotDispositionReasons] @userId;
		EXEC [npsg].[GetOdmLotDispositionActions] @userId;
		EXEC [npsg].[GetOdmComparisonLotDisposition] @userId, @scenarioId;	
		EXEC [npsg].[GetOdmQualFilterNonQualifiedMedia] @userId, @scenarioId;
		EXEC [npsg].[GetOdmQualFilterNonQualifiedMediaExceptions] @userId, @scenarioId;	
	END TRY

	BEGIN CATCH
		DECLARE @errorMessage VARCHAR(MAX) = ERROR_MESSAGE();
		DECLARE @errorSeverity INT = ERROR_SEVERITY();
		DECLARE @errorState INT = ERROR_STATE();

		ROLLBACK TRAN BatchUpdate
		RAISERROR (@errorMessage, @errorSeverity, @errorState);
	END CATCH
END