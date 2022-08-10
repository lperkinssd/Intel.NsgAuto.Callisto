-- ===================================================
-- Author       : bricschx
-- Create date  : 2020-10-09 11:23:41.670
-- Description  : Imports speed data into the system
-- Example      : EXEC [qan].[TaskSpeedImport];
-- ===================================================
CREATE PROCEDURE [qan].[TaskSpeedImport]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText NVARCHAR(4000);
	DECLARE @TaskId BIGINT;

	BEGIN TRY

		EXEC [CallistoCommon].[stage].[CreateTaskByName] @TaskId OUTPUT, 'Speed Import';

		DECLARE @By VARCHAR(25) = [qan].[CreatedByTask](@TaskId);
		DECLARE @Count INT = 0;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 0, 'Creating new BOM association types';
		EXEC [qan].[CreateNewSpeedBomAssociationTypes] @Count OUTPUT, @By;
		SET @MessageText = 'New BOM association types inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 20, 'Creating new customers';
		EXEC [qan].[CreateNewSpeedCustomers] @Count OUTPUT, @By;
		SET @MessageText = 'New customers inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 40, 'Creating new form factors';
		EXEC [qan].[CreateNewSpeedFormFactors] @Count OUTPUT, @By;
		SET @MessageText = 'New form factors inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 60, 'Creating new product families';
		EXEC [qan].[CreateNewSpeedProductFamilies] @Count OUTPUT, @By;
		SET @MessageText = 'New product families inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 80, 'Creating new designs';
		EXEC [qan].[CreateNewSpeedDesigns] @Count OUTPUT, @By;
		SET @MessageText = 'New designs inserted: ' + CAST(@Count AS VARCHAR);
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
