-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-06-24 15:04:18.703
-- Description  : Gets osat qual filter import
-- Example      : EXEC [qan].[GetOsatQualFilterImports] 'bricschx', 1;
-- =======================================================================
CREATE PROCEDURE [qan].[GetOsatQualFilterImports]
(
	  @UserId VARCHAR(25)
	, @Id     INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [qan].[FOsatQualFilterImports](@UserId, @Id) ORDER BY [Id] DESC;

END
