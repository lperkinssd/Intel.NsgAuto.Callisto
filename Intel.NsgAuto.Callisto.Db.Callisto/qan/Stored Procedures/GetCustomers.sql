-- ==================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-29 12:01:27.717
-- Description  : Gets customers
-- Example      : EXEC [qan].[GetCustomers] 'bricschx'
-- ==================================================================================
CREATE PROCEDURE [qan].[GetCustomers]
(
	  @UserId VARCHAR(25)
	, @Id INT = NULL
	, @Name VARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		  C.[Id]
		, C.[Name]
		, C.[NameSpeed]
		, C.[CreatedBy]
		, C.[CreatedOn]
		, C.[UpdatedBy]
		, C.[UpdatedOn]
	FROM [qan].[Customers] AS C WITH (NOLOCK)
	WHERE (@Id IS NULL OR C.[Id] = @Id) AND (@Name IS NULL OR C.[Name] = @Name)
	ORDER BY C.[Name];

END
