-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16
-- Description  : Gets osat attribute types
-- Example      : SELECT * FROM [qan].[FOsatAttributeTypes](NULL, NULL, NULL);
-- ============================================================================
CREATE FUNCTION [qan].[FOsatAttributeTypes]
(
	  @Id         INT         = NULL
	, @Name       VARCHAR(50) = NULL
	, @DataTypeId INT         = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  A.[Id]
		, A.[Name]
		, A.[NameDisplay]
		, A.[DataTypeId]
		, D.[Name] AS [DataTypeName]
		, D.[NameDisplay] AS [DataTypeNameDisplay]
		, A.[CreatedBy]
		, A.[CreatedOn]
		, A.[UpdatedBy]
		, A.[UpdatedOn]
	FROM [qan].[OsatAttributeTypes] AS A WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[OsatAttributeDataTypes] AS D WITH (NOLOCK) ON (D.[Id] = A.[DataTypeId])
	WHERE (@Id IS NULL OR A.[Id] = @Id)
	  AND (@Name IS NULL OR A.[Name] = @Name)
	  AND (@DataTypeId IS NULL OR A.[DataTypeId] = @DataTypeId)
)
