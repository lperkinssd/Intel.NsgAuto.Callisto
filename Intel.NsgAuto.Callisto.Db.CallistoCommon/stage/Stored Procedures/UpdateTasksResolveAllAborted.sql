-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-08-05 12:16:12.470
-- Description  : Resolves all unresolved aborted tasks for a given task type
-- Example      : EXEC [stage].[UpdateTasksResolveAllAborted] 'bricschx', 1, 'bricschx';
-- ======================================================================================
CREATE PROCEDURE [stage].[UpdateTasksResolveAllAborted]
(
	  @UserId      VARCHAR(25)
	, @TaskTypeId  INT
	, @ResolvedBy  VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [stage].[Tasks] SET [ResolvedDateTime] = GETUTCDATE(), [ResolvedBy] = @ResolvedBy WHERE [TaskTypeId] = @TaskTypeId AND [EndDateTime] IS NULL AND [AbortDateTime] IS NOT NULL AND [ResolvedDateTime] IS NULL;

END
