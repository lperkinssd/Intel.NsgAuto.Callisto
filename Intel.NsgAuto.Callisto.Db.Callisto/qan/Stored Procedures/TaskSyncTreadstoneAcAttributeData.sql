-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-23 12:31:31.833
-- Description  : Task for synchronizing data associated with auto checker attributes from treadstone
-- Example      : EXEC [qan].[TaskSyncTreadstoneAcAttributeData];
-- =====================================================================================================
CREATE PROCEDURE [qan].[TaskSyncTreadstoneAcAttributeData]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText NVARCHAR(4000);
	DECLARE @TaskId BIGINT;

	BEGIN TRY

		EXEC [CallistoCommon].[stage].[CreateTaskByName] @TaskId OUTPUT, 'Sync Treadstone Auto Checker Attribute Data';

		DECLARE @By     VARCHAR(25) = [qan].[CreatedByTask](@TaskId);
		DECLARE @Count  INT         = 0;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 0, 'Creating new designs';
		EXEC [qan].[CreateNewTreadstoneDesigns] @Count OUTPUT, @By;
		SET @MessageText = 'New designs inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 20, 'Creating new fabrication facilities';
		EXEC [qan].[CreateNewTreadstoneFabricationFacilities] @Count OUTPUT, @By;
		SET @MessageText = 'New fabrication facilities inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 40, 'Creating new test flows';
		EXEC [qan].[CreateNewTreadstoneTestFlows] @Count OUTPUT, @By;
		SET @MessageText = 'New test flows inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 60, 'Creating new probe conversions';
		EXEC [qan].[CreateNewTreadstoneProbeConversions] @Count OUTPUT, @By;
		SET @MessageText = 'New probe conversions inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 80, 'Creating new attribute type values';
		EXEC [qan].[CreateNewTreadstoneAttributeTypeValues] @Count OUTPUT, @By;
		SET @MessageText = 'New attribute type values inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskEnd] @TaskId;

	END TRY
	BEGIN CATCH
		
		IF (@TaskId IS NOT NULL)
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
