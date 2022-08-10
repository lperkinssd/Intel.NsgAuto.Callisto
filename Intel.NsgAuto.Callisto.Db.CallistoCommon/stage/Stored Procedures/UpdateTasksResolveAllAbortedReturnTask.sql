-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-08-05 12:48:52.937
-- Description  : Resolves all unresolved aborted tasks for a given task type. The task type is
--                determined by the task id parameter supplied.
-- Example      : EXEC [stage].[UpdateTasksResolveAllAbortedReturnTask] 'bricschx', 1, 'bricschx';
-- ================================================================================================
CREATE PROCEDURE [stage].[UpdateTasksResolveAllAbortedReturnTask]
(
	  @UserId      VARCHAR(25)
	, @TaskId      BIGINT
	, @ResolvedBy  VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @TaskTypeId INT;

	SELECT @TaskTypeId = MIN([TaskTypeId]) FROM [stage].[Tasks] WITH (NOLOCK) WHERE [Id] = @TaskId;

	IF (@TaskTypeId IS NOT NULL)
	BEGIN
		EXEC [stage].[UpdateTasksResolveAllAborted] @UserId, @TaskTypeId, @ResolvedBy;
	END;

	EXEC [stage].[GetTasks] @UserId, @TaskId;

END
