



-- ======================================================================================
-- Author       : jkurian (refactored by bricschx)
-- Create date  : 2020-09-15 15:58:12.463
-- Description  : Creates a new odm qual filter scenario
-- Example      : EXEC [npsg].[TaskCreateOdmQualFilterScenario];
-- Notes        : Copied and tweaked from [npsg].[CreateOdmQualFilterScenario]. Every time
--                a new scenario is created, its status is automatically 'Current'. All
--                other scenarios are either 'Modified' or 'Published'. Do not return
--                result sets from this stored procedure, create a wrapper if needed.
-- ======================================================================================
CREATE PROCEDURE [npsg].[TaskCreateOdmQualFilterScenario]
	  @Id            INT         = NULL OUTPUT
	, @CountInserted INT         = NULL OUTPUT
	, @UserId        VARCHAR(25) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText  NVARCHAR(4000);
	DECLARE @TaskId       BIGINT;	
	DECLARE @LatestPRFVersion INT = (SELECT ISNULL(MAX([PrfVersion]), 0) FROM [npsg].[PRFDCR] WITH (NOLOCK));
	DECLARE @LatestMATVersion INT = (SELECT ISNULL(MAX([MatVersion]), 0) FROM [npsg].[MAT] WITH (NOLOCK));
	DECLARE @LatestWIPVersion INT = (SELECT ISNULL(MAX([Version]), 0) FROM [npsg].[OdmWipSnapshots] WITH (NOLOCK));
	DECLARE @LatestShipVersion INT = (SELECT ISNULL(MAX([Version]), 0) FROM [npsg].[OdmLotShipSnapshots] WITH (NOLOCK));
	DECLARE @LatestManualDispositionsVersion INT = (SELECT ISNULL(MAX([Version]), 0) FROM [npsg].[OdmManualDispositions] WITH (NOLOCK));

	BEGIN TRY

		EXEC [CallistoCommon].[stage].[CreateTaskByName] @TaskId OUTPUT, 'Create ODM QF NPSG Scenario';

		SET @CountInserted = 0;
		IF (@UserId IS NULL) SET @UserId = [npsg].[CreatedByTask](@TaskId);

		BEGIN TRAN CreateScenario

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 0, 'Determining latest scenario information';

		DECLARE @DailyId INT;
		DECLARE @LatestScenarioId INT = (SELECT MAX([Id]) FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK));
		DECLARE @LatestScenarioDate DATETIME2(7) = (SELECT MAX([CreatedOn]) FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE [Id] = @LatestScenarioId);
		DECLARE @ScenarioDate DATETIME2(7) = GETDATE(); -- should this be GETUTCDATE() ?

		SET @MessageText = 'Latest scenario information; Id = ' + ISNULL(CAST(@LatestScenarioId AS VARCHAR(20)), 'null') + '; Date = ' + ISNULL(CONVERT(VARCHAR, @LatestScenarioDate, 23), 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		IF (@LatestScenarioDate IS NULL) SET @LatestScenarioDate = @ScenarioDate;

		DECLARE @IsNewDay INT = DATEDIFF(dd, @LatestScenarioDate, @ScenarioDate);
	
		IF (@IsNewDay > 0 OR @LatestScenarioId IS NULL)
		BEGIN
			SET @DailyId = 1;
		END
		ELSE
		BEGIN
			SET @DailyId = (SELECT ISNULL([DailyId], 0) + 1 FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE [Id] = @LatestScenarioId);
		END;

		SET @MessageText = 'Is New Day = ' + ISNULL(CAST(@IsNewDay AS VARCHAR(20)), 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 25, 'Inserting new scenario';

		INSERT INTO [npsg].[OdmQualFilterScenarios]
		(
			  [PrfVersion]
			, [MatVersion]
			, [OdmWipSnapshotVersion]
			, [LotShipSnapshotVersion]
			, [LotDispositionSnapshotVersion]
			, [ManualDispositionsVersion]
			, [DailyId]
			, [StatusId]
			, [CreatedBy]
			, [CreatedOn]
		)
		VALUES
		(
			  @LatestPRFVersion
			, @LatestMATVersion
			, @LatestWIPVersion
			, @LatestShipVersion
			, NULL                -- null for now, because we will create the new lot disposiotion snapshot later and update this entry
			, @LatestManualDispositionsVersion
			, @DailyId
			, 1                   -- Current
			, @UserId
			, @ScenarioDate
		);

		SELECT @Id = SCOPE_IDENTITY();

		SET @MessageText =    'New scenario inserted; Id = '   + ISNULL(CAST(@Id                AS VARCHAR(20)), 'null')
							+ '; PRF Version = '               + ISNULL(CAST(@LatestPRFVersion  AS VARCHAR(20)), 'null')
							+ '; MAT Version = '               + ISNULL(CAST(@LatestMATVersion  AS VARCHAR(20)), 'null')
							+ '; WIP Snapshot Version = '      + ISNULL(CAST(@LatestWIPVersion  AS VARCHAR(20)), 'null')
							+ '; Lot Ship Snapshot Version = ' + ISNULL(CAST(@LatestShipVersion AS VARCHAR(20)), 'null')
							+ '; Manual Dispositions Version = ' + ISNULL(CAST(@LatestManualDispositionsVersion AS VARCHAR(20)), 'null')
							+ '; Daily Id = '                  + ISNULL(CAST(@DailyId           AS VARCHAR(20)), 'null')
							+ '; User Id = '                   + ISNULL(@UserId                                , 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 50, 'Executing [npsg].[CreateOdmQualFilters]';
		EXEC [npsg].[CreateOdmQualFilters] @Id, @UserId;

		SELECT @CountInserted = COUNT(*) FROM [npsg].[OdmQualFilters] WITH (NOLOCK) WHERE [ScenarioId] = @Id;
		SET @MessageText = 'Number of records inserted into [npsg].[OdmQualFilters]: ' + ISNULL(CAST(@CountInserted AS VARCHAR(20)), 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskEnd] @TaskId;

		COMMIT TRAN CreateScenario
	END TRY
	BEGIN CATCH

		SET @MessageText = 'Error occurred in [npsg].[TaskCreateOdmQualFilterScenario] / [npsg].[CreateOdmQualFilters] at line# ' + CAST(ERROR_LINE() AS NVARCHAR(50)) + ': ' + CAST(ERROR_MESSAGE() AS NVARCHAR(4000));
		DECLARE @errorSeverity INT = ERROR_SEVERITY();
		DECLARE @errorState INT = ERROR_STATE();

		ROLLBACK TRAN CreateScenario

		IF @Id IS NOT NULL
		BEGIN
			--INSERT INTO [npsg].[OdmQualFilterAttemptedScenarios]
			--	   ([AttemptedScenarioId]
			--	   ,[FailedReason]
			--	   ,[AttemptedOn]
			--	   ,[AttemptedBy])
			-- VALUES
			--	   (@Id
			--	   ,@MessageText
			--	   ,GETDATE()
			--	   ,@UserId)

			INSERT INTO [npsg].[OdmQualFilterAttemptedScenarios]
				   ([AttemptedScenarioId]
				   ,[FailedReason]
				   ,[AttemptedOn]
				   ,[AttemptedBy]
				   ,[PrfVersion]
				   ,[MatVersion]
				   ,[OdmWipSnapshotVersion]
				   ,[LotShipSnapshotVersion]
				   ,[LotDispositionSnapshotVersion]
				   ,[ManualDispositionsVersion])
			 VALUES
				   (@Id
				   ,@MessageText
				   ,GETDATE()
				   ,@UserId
				   ,@LatestPRFVersion
				   ,@LatestMATVersion
				   ,@LatestWIPVersion
				   ,@LatestShipVersion
				   ,NULL
				   ,@LatestManualDispositionsVersion)

		END

		IF @TaskId IS NOT NULL
		BEGIN
			BEGIN TRY
				EXEC [CallistoCommon].[stage].[UpdateTaskAbort] @TaskId;
				EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Abort', @MessageText;
			END TRY
			BEGIN CATCH
			END CATCH;
		END;

		RAISERROR (@MessageText, @errorSeverity, @errorState);
	END CATCH;

END