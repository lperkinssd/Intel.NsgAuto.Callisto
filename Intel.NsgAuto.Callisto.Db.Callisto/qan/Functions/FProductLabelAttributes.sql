-- ===============================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-12 12:27:56.557
-- Description  : Gets product label attributes
-- Example      : SELECT * FROM [qan].[FProductLabelAttributes](NULL, NULL, 1);
-- ===============================================================================================
CREATE FUNCTION [qan].[FProductLabelAttributes]
(
	  @Id BIGINT = NULL
	, @ProductLabelId BIGINT = NULL
	, @ProductLabelSetVersionId INT = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  A.[Id]
		, A.[ProductLabelId]
		, A.[AttributeTypeId]
		, T.[Name] AS [AttributeTypeName]
		, T.[NameDisplay] AS [AttributeTypeNameDisplay]
		, A.[Value]
		, A.[CreatedBy]
		, A.[CreatedOn]
		, A.[UpdatedBy]
		, A.[UpdatedOn]
	FROM [qan].[ProductLabelAttributes] AS A WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[ProductLabelAttributeTypes] AS T WITH (NOLOCK) ON (A.[AttributeTypeId] = T.[Id])
	WHERE (@Id IS NULL OR A.[Id] = @Id)
	  AND (@ProductLabelId IS NULL OR A.[ProductLabelId] = @ProductLabelId)
	  AND (@ProductLabelSetVersionId IS NULL OR A.[ProductLabelId] IN (SELECT [Id] FROM [ProductLabels] WITH (NOLOCK) WHERE [ProductLabelSetVersionId] = @ProductLabelSetVersionId))
)
