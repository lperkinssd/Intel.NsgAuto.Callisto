-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-15 15:58:12.463
-- Description  : A template for creating new tasks
-- Example      : EXEC [stage].[TaskTemplate];
-- Notes        : All tasks should begin with the word Task. This will clearly
--                distinguish stored procedures that have task support from those
--                that do not. It will also group them all together in the SSMS.
--                All calls to task procedures in this template are prefixed with
--                [CallistoCommon].* so that this template will work in any database
--                that resides on the same server, for example Callisto. However, if
--                the new task will actually be in CallistoCommon, it is probably
--                best practice to remove the [CallistoCommon] prefixes.
-- ======================================================================================
CREATE PROCEDURE [stage].[TaskTemplate]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText  NVARCHAR(4000);
	DECLARE @TaskId       BIGINT;

	BEGIN TRY

		EXEC [CallistoCommon].[stage].[CreateTaskByName] @TaskId OUTPUT, 'Template'; -- TODO: change 'Template' to correct task type name

		-- section: task code

		-- TODO: insert code here

		-- example messages
		-- SET @MessageText = 'Example informational message';
		-- EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		-- SET @MessageText = 'Example warning message';
		-- EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Warning', @MessageText;

		-- SET @MessageText = 'Example error message';
		-- EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Error', @MessageText;

		-- uncomment the line below to test what happens if an error occurs
		-- THROW 50000, 'Example error', 1;

		-- end section: task code

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
