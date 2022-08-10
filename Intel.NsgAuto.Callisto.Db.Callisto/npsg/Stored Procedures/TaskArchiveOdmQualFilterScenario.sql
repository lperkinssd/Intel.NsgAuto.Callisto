


-- ==================================================================================================================================================
-- Author       : ftianx
-- Create date  : 2021-10-25 12:58:28.108
-- Description  : Archive NPSG ODM QF data to history tables
-- Example      : DECLARE @userId VARCHAR(50) = 'system';
--                
--                EXEC [npsg].[TaskArchiveOdmQualFilterScenario] @userId 
 -- ==================================================================================================================================================
CREATE PROCEDURE [npsg].[TaskArchiveOdmQualFilterScenario]
(
	@userId VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @taskId BIGINT;

	BEGIN TRY
		EXEC [CallistoCommon].[stage].[CreateTaskByName] @taskId OUTPUT, 'Archive NPSG ODM QF Scenario';

		DECLARE @latestScenarioId INT
		DECLARE @largestScenarioIdToArchive INT
		DECLARE @latestScenarioCreatedOn DATETIME2(7)
		DECLARE @latestScenarioDate DATETIME2(7)

		SELECT @latestScenarioId = MAX(Id) FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK)
		IF @latestScenarioId IS NULL RETURN

		SELECT @latestScenarioCreatedOn = CreatedOn FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE Id = @latestScenarioId
		SET @latestScenarioDate = DATEADD(DD, DATEDIFF(DD, 0, @latestScenarioCreatedOn), 0)
		SELECT @largestScenarioIdToArchive = MIN(Id) FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE [CreatedOn] >= @latestScenarioDate
		IF @largestScenarioIdToArchive IS NULL RETURN

		DECLARE @largestOdmWipSnapshotVersionToArchive INT
				, @largestLotShipSnapshotVersionToArchive INT
				, @largestOdmWipSnapshotVersion INT
				, @largestLotShipSnapshotVersion INT

		SELECT @largestOdmWipSnapshotVersionToArchive = [OdmWipSnapshotVersion]
				,@largestLotShipSnapshotVersionToArchive = [LotShipSnapshotVersion]
		FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK)
		WHERE [Id] = @largestScenarioIdToArchive

		BEGIN TRAN OdmHistory

		-- Archive OdmWipSnapshots
		INSERT INTO [npsg].[OdmWipSnapshotsHistory]
		SELECT *, GETDATE(), @userId FROM [npsg].[OdmWipSnapshots] WITH (NOLOCK)
		WHERE Version < @largestOdmWipSnapshotVersionToArchive

		DELETE FROM [npsg].[OdmWipSnapshots] 
		WHERE Version < @largestOdmWipSnapshotVersionToArchive

		-- Archive OdmLotShipSnapshots
		INSERT INTO [npsg].[OdmLotShipSnapshotsHistory]
		SELECT *, GETDATE(), @userId FROM [npsg].[OdmLotShipSnapshots] WITH (NOLOCK)
		WHERE Version < @largestLotShipSnapshotVersionToArchive

		DELETE FROM [npsg].[OdmLotShipSnapshots] 
		WHERE Version < @largestLotShipSnapshotVersionToArchive
		
		-- Archive OdmQualFilters
		INSERT INTO [npsg].[OdmQualFiltersHistory]
		SELECT *, GETDATE(), @userId FROM [npsg].[OdmQualFilters] WITH (NOLOCK)
		WHERE ScenarioId < @largestScenarioIdToArchive

		DELETE FROM [npsg].[OdmQualFilters] 
		WHERE ScenarioId < @largestScenarioIdToArchive

		-- Archive OdmQualFilterLotDispositions
		INSERT INTO [npsg].[OdmQualFilterLotDispositionsHistory]
		SELECT *, GETDATE(), @userId FROM [npsg].[OdmQualFilterLotDispositions] WITH (NOLOCK)
		WHERE ScenarioId < @largestScenarioIdToArchive

		DELETE FROM [npsg].[OdmQualFilterLotDispositions] 
		WHERE ScenarioId < @largestScenarioIdToArchive

		COMMIT TRAN OdmHistory
		EXEC [CallistoCommon].[stage].[UpdateTaskEnd] @taskId;
	END TRY
	BEGIN CATCH		
		DECLARE @errorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @errorSeverity INT = ERROR_SEVERITY();
		DECLARE @errorState INT = ERROR_STATE();
		DECLARE @errorLine INT = ERROR_LINE();

		IF @taskId IS NOT NULL
		BEGIN
			BEGIN TRY
				SET @errorMessage = @errorMessage + ' occurred at line ' + CAST(@errorLine AS NVARCHAR(50)) ;
				EXEC [CallistoCommon].[stage].[UpdateTaskAbort] @taskId;
				EXEC [CallistoCommon].[stage].[CreateTaskMessage] @taskId, 'Abort', @errorMessage;
			END TRY
			BEGIN CATCH
			END CATCH;
		END;

		ROLLBACK TRAN OdmHistory
		RAISERROR (@errorMessage, @errorSeverity, @errorState);
	END CATCH;

END