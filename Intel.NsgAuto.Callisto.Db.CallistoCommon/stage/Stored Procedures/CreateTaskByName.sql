-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-06-07 16:32:37.813
-- Description  : Creates a task by name
-- Example      : DECLARE @TaskId INT;
--                EXEC [stage].[CreateTaskByName] @TaskId OUTPUT, 'Template';
--                PRINT @TaskId;
-- ============================================================================
CREATE PROCEDURE [stage].[CreateTaskByName]
(
	  @Id            BIGINT                   OUTPUT
	, @TaskTypeName  VARCHAR(100)
	, @Status        VARCHAR(50)  = 'Started'
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TaskTypeId INT = [ref].[GetTaskTypeId](@TaskTypeName);

	SET @Id = NULL;

	EXEC [stage].[CreateTask] @Id OUTPUT, @TaskTypeId, @Status;

END
