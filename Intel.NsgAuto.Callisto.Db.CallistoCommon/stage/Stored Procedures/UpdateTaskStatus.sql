-- =============================================================
-- Author       : bricschx
-- Create date  : 2020-09-15 14:36:17.083
-- Description  : Updates the status for a task
-- =============================================================
CREATE PROCEDURE [stage].[UpdateTaskStatus]
(
	  @Id      BIGINT
	, @Status  VARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [stage].[Tasks] SET [Status] = @Status WHERE [Id] = @Id;

END
