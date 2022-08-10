-- ============================================================================
-- Author       : bricschx
-- Create date  : 2020-09-22 09:31:41.783
-- Description  : Resolves a task
-- Example      : EXEC [stage].[UpdateTaskResolved] 'bricschx', 1, 'bricschx';
-- ============================================================================
CREATE PROCEDURE [stage].[UpdateTaskResolved]
(
	  @UserId      VARCHAR(25)
	, @Id          BIGINT
	, @ResolvedBy  VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [stage].[Tasks] SET [ResolvedDateTime] = GETUTCDATE(), [ResolvedBy] = @ResolvedBy WHERE [Id] = @Id AND [ResolvedDateTime] IS NULL;

	EXEC [stage].[GetTasks] @UserId, @Id;

END
