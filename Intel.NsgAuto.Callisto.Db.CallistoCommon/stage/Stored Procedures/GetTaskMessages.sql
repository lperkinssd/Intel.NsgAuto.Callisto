-- ==================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-21 21:24:18.730
-- Description  : Gets task messages
-- Example      : EXEC [stage].[GetTaskMessages] 'bricschx', NULL, 1
-- ==================================================================================
CREATE PROCEDURE [stage].[GetTaskMessages]
(
	  @UserId VARCHAR(25)
	, @Id BIGINT = NULL
	, @TaskId BIGINT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		  [Id]
		, [TaskId]
		, [Type]
		, [Text]
		, [CreatedOn]
	FROM [stage].[TaskMessages] WITH (NOLOCK)
	WHERE (@Id IS NULL OR [Id] = @Id) AND (@TaskId IS NULL OR [TaskId] = @TaskId)
	ORDER BY [Id];

END
