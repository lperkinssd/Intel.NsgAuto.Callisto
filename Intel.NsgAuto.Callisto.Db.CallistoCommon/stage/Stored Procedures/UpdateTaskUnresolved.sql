-- ==================================================================
-- Author       : bricschx
-- Create date  : 2020-09-22 09:31:41.783
-- Description  : Unresolves a task
-- Example      : EXEC [stage].[UpdateTaskUnresolved] 'bricschx', 1;
-- ==================================================================
CREATE PROCEDURE [stage].[UpdateTaskUnresolved]
(
	  @UserId  VARCHAR(25)
	, @Id      BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [stage].[Tasks] SET [ResolvedDateTime] = NULL, [ResolvedBy] = NULL WHERE [Id] = @Id AND [ResolvedDateTime] IS NOT NULL;

	EXEC [stage].[GetTasks] @UserId, @Id;

END
