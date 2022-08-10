-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-06-08 19:28:07.247
-- Description  : Gets osat qual filter exports
-- Example      : EXEC [qan].[GetOsatQualFilterExports] 'bricschx', 1;
-- =======================================================================
CREATE PROCEDURE [qan].[GetOsatQualFilterExports]
(
	  @UserId VARCHAR(25)
	, @Id     INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [qan].[FOsatQualFilterExports](@Id) ORDER BY [Id] DESC;

END
