-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-06-04 17:05:54.330
-- Description  : Gets all data required for the osat qual filter publish view
-- Example      : EXEC [qan].[GetOsatQualFilterPublish] 'bricschx', 1;
-- ============================================================================
CREATE PROCEDURE [qan].[GetOsatQualFilterPublish]
(
	  @UserId    VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;

	-- result set #1: designs
	SELECT * FROM [qan].[FProducts](NULL, @UserId, NULL, NULL, NULL, NULL) ORDER BY [Name];

	-- result set #2: osats
	SELECT * FROM [qan].[Osats] WITH (NOLOCK) ORDER BY [Name];

	-- result set #3: exports
	SELECT TOP 200 * FROM [qan].[FOsatQualFilterExports](NULL) ORDER BY [Id] DESC;

END
