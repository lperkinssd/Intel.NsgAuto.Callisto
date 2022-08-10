-- =============================================================
-- Author       : bricschx
-- Create date  : 2020-10-19 11:06:07.527
-- Description  : Updates the progress for a task
-- =============================================================
CREATE PROCEDURE [stage].[UpdateTaskProgress]
(
	  @Id               BIGINT
	, @ProgressPercent  TINYINT      = NULL
	, @ProgressText     VARCHAR(200) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [stage].[Tasks] SET [ProgressPercent] = @ProgressPercent, [ProgressText] = @ProgressText WHERE [Id] = @Id;

END
