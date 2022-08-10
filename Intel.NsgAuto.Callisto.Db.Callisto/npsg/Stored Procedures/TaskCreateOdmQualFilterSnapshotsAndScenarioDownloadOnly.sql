-- ============================================================================
-- Author      : ftianx
-- Create date : 2021-03-08 14:56:11.377
-- Description : Create odm wip snapshot, lot ship snapshot, and a new scenario 
--               without history tracking step
-- Example     : EXEC [npsg].[TaskCreateOdmQualFilterSnapshotsAndScenarioDownloadOnly];
-- ============================================================================
CREATE PROCEDURE [npsg].[TaskCreateOdmQualFilterSnapshotsAndScenarioDownloadOnly]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText  NVARCHAR(4000);
	DECLARE @TaskId       BIGINT;

	BEGIN TRY

		EXEC [CallistoCommon].[stage].[CreateTaskByName] @TaskId OUTPUT, 'Create ODM QF NPSG Snapshots And Scenario DownloadOnly';

		DECLARE @By    VARCHAR(25) = [npsg].[CreatedByTask](@TaskId);
		DECLARE @Count INT         = 0;
		DECLARE @Id    INT;
		
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 0, 'Executing [npsg].[TaskCreateOdmQualFilterHistoricalWipBohSnapshot]';
		EXEC [npsg].[TaskCreateOdmQualFilterHistoricalWipBohSnapshot] @Count OUTPUT;
		SET @MessageText = 'BOH Historical WIP snapshot records inserted: ' + ISNULL(CAST(@Count AS VARCHAR(20)), 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 0, 'Executing [npsg].[TaskCreateOdmQualFilterWipSnapshot]';
		EXEC [npsg].[TaskCreateOdmQualFilterWipSnapshot] @Count OUTPUT;
		SET @MessageText = 'WIP snapshot records inserted: ' + ISNULL(CAST(@Count AS VARCHAR(20)), 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 25, 'Executing [TaskCreateOdmQualFilterLostShipSnapshot]';
		EXEC [npsg].[TaskCreateOdmQualFilterLotShipSnapshot] @Count OUTPUT;
		SET @MessageText = 'Lot ship snapshot records inserted: ' + ISNULL(CAST(@Count AS VARCHAR(20)), 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 50, 'Executing [npsg].[TaskCreateOdmQualFilterScenario]';
		EXEC [npsg].[TaskCreateOdmQualFilterScenario] @Id OUTPUT, @Count OUTPUT;
		SET @MessageText = 'New scenario; Id = ' + ISNULL(CAST(@Id AS VARCHAR(20)), 'null') + '; Records inserted = ' + ISNULL(CAST(@Count AS VARCHAR(20)), 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskEnd] @TaskId;

	END TRY
	BEGIN CATCH
		
		IF @TaskId IS NOT NULL
		BEGIN
			BEGIN TRY
				SET @MessageText = CAST(ERROR_MESSAGE() AS NVARCHAR(4000));
				EXEC [CallistoCommon].[stage].[UpdateTaskAbort] @TaskId;
				EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Abort', @MessageText;
			END TRY
			BEGIN CATCH
			END CATCH;
		END;

		THROW;

	END CATCH;
END