-- ============================================================================
-- Author      : bricschx
-- Create date : 2021-03-05 14:56:11.377
-- Description : Create odm wip snapshot, lot ship snapshot, and a new scenario
-- Example     : EXEC [qan].[TaskCreateOdmQualFilterSnapshotsAndScenario];
-- ============================================================================
CREATE PROCEDURE [qan].[TaskCreateOdmQualFilterSnapshotsAndScenario]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText  NVARCHAR(4000);
	DECLARE @TaskId       BIGINT;

	BEGIN TRY

		EXEC [CallistoCommon].[stage].[CreateTaskByName] @TaskId OUTPUT, 'Create ODM QF Snapshots And Scenario';

		DECLARE @By    VARCHAR(25) = [qan].[CreatedByTask](@TaskId);
		DECLARE @Count INT         = 0;
		DECLARE @Id    INT;
		
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 0, 'Executing [qan].[TaskCreateOdmQualFilterHistoricalWipBohSnapshot]';
		EXEC [qan].[TaskCreateOdmQualFilterHistoricalWipBohSnapshot] @Count OUTPUT;
		SET @MessageText = 'BOH Historical WIP snapshot records inserted: ' + ISNULL(CAST(@Count AS VARCHAR(20)), 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 0, 'Executing [qan].[TaskCreateOdmQualFilterWipSnapshot]';
		EXEC [qan].[TaskCreateOdmQualFilterWipSnapshot] @Count OUTPUT;
		SET @MessageText = 'WIP snapshot records inserted: ' + ISNULL(CAST(@Count AS VARCHAR(20)), 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 25, 'Executing [TaskCreateOdmQualFilterLostShipSnapshot]';
		EXEC [qan].[TaskCreateOdmQualFilterLotShipSnapshot] @Count OUTPUT;
		SET @MessageText = 'Lot ship snapshot records inserted: ' + ISNULL(CAST(@Count AS VARCHAR(20)), 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 50, 'Executing [qan].[TaskCreateOdmQualFilterScenario]';
		EXEC [qan].[TaskCreateOdmQualFilterScenario] @Id OUTPUT, @Count OUTPUT;
		SET @MessageText = 'New scenario; Id = ' + ISNULL(CAST(@Id AS VARCHAR(20)), 'null') + '; Records inserted = ' + ISNULL(CAST(@Count AS VARCHAR(20)), 'null');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 75, 'Executing [qan].[TaskArchiveOdmQualFilterScenario]';
		EXEC [qan].[TaskArchiveOdmQualFilterScenario] 'system';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', 'Successfully archived IOG ODM QF Scenario';

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