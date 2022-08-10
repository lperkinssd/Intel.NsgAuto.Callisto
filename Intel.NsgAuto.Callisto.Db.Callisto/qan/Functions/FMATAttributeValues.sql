-- ========================================================================
-- Author       : bricschx
-- Create date  : 2020-10-12 13:58:33.270
-- Description  : Gets MAT attribute values
-- Example      : SELECT * FROM [qan].[FMATAttributeValues](NULL, NULL, 1);
-- ========================================================================
CREATE FUNCTION [qan].[FMATAttributeValues]
(
	  @Id INT
	, @MATId INT
	, @MATVersionId INT
)
RETURNS TABLE AS RETURN
(
	SELECT
		  V.[Id]
		, V.[MATId]
		, V.[AttributeTypeId] AS [MATAttributeTypeId]
		, T.[Name] AS [MATAttributeTypeName]
		, T.[NameDisplay] AS [MATAttributeTypeNameDisplay]
		, V.[Value]
		, V.[Operator]
		, V.[DataType]
		, V.[CreatedBy]
		, V.[CreatedOn]
		, V.[UpdatedBy]
		, V.[UpdatedOn]
	FROM [qan].[MATAttributeValues] AS V WITH (NOLOCK)
	INNER JOIN [ref].[MATAttributeTypes] AS T WITH (NOLOCK) ON (T.[Id] = V.[AttributeTypeId])
	WHERE (@Id IS NULL OR V.[Id] = @Id)
	  AND (@MATId IS NULL OR V.[MATId] = @MATId)
	  AND (@MATVersionId IS NULL OR V.[MATId] IN (SELECT [Id] FROM [MATs] WITH (NOLOCK) WHERE [MATVersionId] = @MATVersionId))
)
