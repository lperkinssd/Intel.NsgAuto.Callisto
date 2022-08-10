


-- =============================================
-- Author:		jakemurx
-- Create date: 2021-03-23 13:55:34.503
-- Description:	Create or update Odm Qual Filter Lot Disposition
-- =============================================
CREATE PROCEDURE [qan].[CreateOdmQualFilterLotDisposition] 
	@UserId VARCHAR(25),
	@ScenarioId INT,
	@OdmQualFilterId INT, 
	@LotDispositionReasonId INT,
	@Notes VARCHAR(MAX) = NULL,
	@LotDispositionActionId INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Id INT = (SELECT [Id] FROM [qan].[OdmQualFilterLotDispositions] WITH (NOLOCK) WHERE [OdmQualFilterId] = @OdmQualFilterId);
	DECLARE @MarkAsNotQualified INT = 1; -- ref.OdmQualFilterCatagories
	DECLARE @MarkAsQualified INT = 2; -- ref.OdmQualFilterCatagories
	DECLARE @Modified INT = (SELECT Id FROM  ref.OdmQualFilterStatuses WITH (NOLOCK) WHERE [Name] = 'Modified');

	IF @Id IS NULL
		BEGIN
			INSERT INTO [qan].[OdmQualFilterLotDispositions]
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
				(@ScenarioId
				,@OdmQualFilterId
				,@LotDispositionReasonId
				,@Notes
				,@LotDispositionActionId
				,GETDATE()
				,@UserId
				,GETDATE()
				,@UserId)
		END
	ELSE
	BEGIN
		UPDATE [qan].[OdmQualFilterLotDispositions]
		SET  [LotDispositionReasonId] = @LotDispositionReasonId
			,[Notes] = @Notes
			,[LotDispositionActionId] = @LotDispositionActionId
			,[UpdatedOn] = GETDATE()
			,[UpdatedBy] = @UserId
		WHERE [Id] = @Id

		IF @LotDispositionActionId = @MarkAsQualified
			--Copy qan.OdmQualFilters record to qan.OdmQualFilterNonQualifiedMediaExceptions
			BEGIN

				--INSERT INTO [qan].[OdmQualFilterNonQualifiedMediaExceptions] ([ScenarioId], [OdmId], [SCodeMMNumber], [MediaIPN], [SLot])
				--	SELECT [ScenarioId], [OdmId], [SCode], [MediaIPN], [SLot]
				--	FROM [qan].[OdmQualFilters]  WITH (NOLOCK) 
				--	WHERE [Id] = @Id;

				MERGE [qan].[OdmQualFilterNonQualifiedMediaExceptions] AS TRG
				USING
				(
						SELECT [ScenarioId], [OdmId], [SCode], [MediaIPN], [SLot]
						FROM [qan].[OdmQualFilters]  WITH (NOLOCK) 
						WHERE [Id] = @Id
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
							,[OdmId]
							,[SCodeMMNumber]
							,[MediaIPN]
							,[SLot])
					 VALUES
						   (SRC.[ScenarioId]
						   ,SRC.[OdmId]
						   ,SRC.[SCode]
						   ,SRC.[MediaIPN]
						   ,SRC.[SLot]
						   );

				UPDATE [qan].[OdmQualFilters]
				SET [OdmQualFilterCategoryId] = @MarkAsQualified
				WHERE [Id] = @OdmQualFilterId;
			END
		ELSE
		-- Remove record from qan.OdmQualFilterNonQualifiedMediaExceptions
		BEGIN
			DECLARE @OdmId INT,
					@Scode VARCHAR(50),
					@MediaIPN VARCHAR(100),
					@SLot VARCHAR(50)

			SELECT @ScenarioId = [ScenarioId],
					@OdmId = [OdmId],
					@Scode = [SCode],
					@MediaIPN = [MediaIPN],
					@SLot = [SLot]
			FROM [qan].[OdmQualFilters] WITH (NOLOCK) 
			WHERE [Id] = @Id;

			DELETE
			FROM [qan].[OdmQualFilterNonQualifiedMediaExceptions]
			WHERE [ScenarioId] = @ScenarioId
				AND [OdmId] = @OdmId
				AND [SCodeMMNumber] = @Scode
				AND [MediaIPN] = @MediaIPN
				AND [SLot] = @SLot;

			UPDATE [qan].[OdmQualFilters]
			SET [OdmQualFilterCategoryId] = @MarkAsNotQualified
			WHERE [Id] = @OdmQualFilterId;

		END

		IF @ScenarioId IS NULL
		BEGIN
			SET @ScenarioId = (SELECT [ScenarioId] FROM [qan].[OdmQualFilterLotDispositions] WITH (NOLOCK) WHERE [OdmQualFilterId] = @OdmQualFilterId);
		END

	END

	UPDATE [qan].[OdmQualFilterScenarios]
		SET [StatusId] = @Modified
	WHERE [Id] = @ScenarioId;

	-- Return fresh data to the UI
	EXEC [qan].[GetOdmQualFilterScenarioVersions] @UserId, @ScenarioId;
	EXEC [qan].[GetOdmLotDispositionReasons] @UserId;
	EXEC [qan].[GetOdmLotDispositionActions] @UserId;
	EXEC [qan].[GetOdmComparisonLotDisposition] @UserId, @ScenarioId;	
	EXEC [qan].[GetOdmQualFilterNonQualifiedMedia] @UserId, @ScenarioId;
	EXEC [qan].[GetOdmQualFilterNonQualifiedMediaExceptions] @UserId, @ScenarioId;
	

END
