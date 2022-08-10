-- ==================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-08 10:46:39.727
-- Description  : Gets form factors
-- Example      : EXEC [qan].[GetFormFactors] 'bricschx'
-- ==================================================================================
CREATE PROCEDURE [qan].[GetFormFactors]
(
	  @UserId VARCHAR(25)
	, @Id INT = NULL
	, @Name VARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		  [Id]
		, [Name]
		, [NameSpeed]
		, [CreatedBy]
		, [CreatedOn]
		, [UpdatedBy]
		, [UpdatedOn]
	FROM [qan].[FormFactors] WITH (NOLOCK)
	WHERE (@Id IS NULL OR [Id] = @Id) AND (@Name IS NULL OR [Name] = @Name)
	ORDER BY [Name];

END
