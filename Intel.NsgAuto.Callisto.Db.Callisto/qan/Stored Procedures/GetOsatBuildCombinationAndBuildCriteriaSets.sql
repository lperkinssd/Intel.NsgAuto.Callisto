-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-16 15:46:27.010
-- Description  : Gets an osat build combination and all associated build criteria sets
-- Example      : EXEC [qan].[GetOsatBuildCombinationAndBuildCriteriaSets] 'bricschx', 1;
-- ======================================================================================
CREATE PROCEDURE [qan].[GetOsatBuildCombinationAndBuildCriteriaSets]
(
	  @UserId              VARCHAR(25)
	, @BuildCombinationId  INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	-- record set #1: build combination
	SELECT * FROM [qan].[FOsatBuildCombinations](ISNULL(@BuildCombinationId, 0), @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [Id];

	-- record set #2: build criteria sets matching the build combination
	SELECT * FROM [qan].[FOsatBuildCriteriaSets](NULL, @UserId, NULL, NULL, NULL, NULL, ISNULL(@BuildCombinationId, 0)) ORDER BY [Id] DESC;

END
