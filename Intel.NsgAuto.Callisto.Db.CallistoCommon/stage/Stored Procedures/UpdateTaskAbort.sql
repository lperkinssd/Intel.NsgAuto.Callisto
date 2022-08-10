-- =============================================================
-- Author       : bricschx
-- Create date  : 2020-09-15 14:36:17.083
-- Description  : Aborts a task
-- =============================================================
CREATE PROCEDURE [stage].[UpdateTaskAbort]
(
	  @Id      BIGINT
	, @Status  VARCHAR(50) = 'Aborted'
)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [stage].[Tasks] SET [AbortDateTime] = GETUTCDATE(), [Status] = @Status WHERE [Id] = @Id AND [AbortDateTime] IS NULL;

END
