-- ===================================================================
-- Author       : bricschx
-- Create date  : 2020-09-28 18:15:12.280
-- Description  : Gets all reference tables for MM recipes
-- Example      : EXEC [qan].[GetMMRecipeReferenceTables] 'bricschx'
-- ===================================================================
CREATE PROCEDURE [qan].[GetMMRecipeReferenceTables]
(
	  @UserId VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM [ref].[CustomerQualStatuses] WITH (NOLOCK) ORDER BY [Id];

	SELECT * FROM [ref].[PLCStages] WITH (NOLOCK) ORDER BY [Id];

END
