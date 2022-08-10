-- ==================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-29 12:12:24.300
-- Description  : Gets product families
-- Example      : EXEC [qan].[GetProductFamilies] 'bricschx'
-- ==================================================================================
CREATE PROCEDURE [qan].[GetProductFamilies]
(
	  @UserId VARCHAR(25)
	, @Id INT = NULL
	, @Name VARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		  P.[Id]
		, P.[Name]
		, P.[NameSpeed]
		, P.[CreatedBy]
		, P.[CreatedOn]
		, P.[UpdatedBy]
		, P.[UpdatedOn]
	FROM [qan].[ProductFamilies] AS P WITH (NOLOCK)
	WHERE (@Id IS NULL OR P.[Id] = @Id) AND (@Name IS NULL OR P.[Name] = @Name)
	ORDER BY P.[Name];

END
