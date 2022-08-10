-- =============================================================
-- Author       : bricschx
-- Create date  : 2020-09-15 14:36:17.083
-- Description  : Ends a task
-- =============================================================
CREATE PROCEDURE [stage].[UpdateTaskEnd]
(
	  @Id      BIGINT
	, @Status  VARCHAR(50) = 'Finished'
)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [stage].[Tasks] SET [EndDateTime] = GETUTCDATE(), [Status] = @Status, [ProgressPercent] = 100, [ProgressText] = NULL WHERE [Id] = @Id AND [EndDateTime] IS NULL;

END
