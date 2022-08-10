-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-06-07 16:32:37.813
-- Description  : Creates a task by name and returns the task record
-- Example      : EXEC [stage].[CreateTaskByNameReturnTask] 'Template';
-- =======================================================================
CREATE PROCEDURE [stage].[CreateTaskByNameReturnTask]
(
	  @TaskTypeName  VARCHAR(100)
	, @Status        VARCHAR(50)  = 'Started'
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Id INT;

	EXEC [stage].[CreateTaskByName] @Id OUTPUT, @TaskTypeName;

	IF (@Id IS NOT NULL)
	BEGIN
		SELECT * FROM [stage].[FTasks](@Id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
	END;

END
