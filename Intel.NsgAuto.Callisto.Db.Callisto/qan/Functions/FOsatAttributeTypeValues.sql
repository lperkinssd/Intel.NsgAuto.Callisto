-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-03 13:13:35.390
-- Description  : Gets osat attribute type values
-- Example      : SELECT * FROM [qan].[FOsatAttributeTypeValues](NULL, NULL, NULL, NULL);
-- ======================================================================================
CREATE FUNCTION [qan].[FOsatAttributeTypeValues]
(
	  @Id                INT         = NULL
	, @AttributeTypeId   INT         = NULL
	, @AttributeTypeName VARCHAR(50) = NULL
	, @Value             VARCHAR(50) = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  V.[Id]
		, V.[AttributeTypeId]
		, A.[Name] AS [AttributeTypeName]
		, V.[Value]
		, V.[ValueDisplay]
		, V.[CreatedBy]
		, V.[CreatedOn]
		, V.[UpdatedBy]
		, V.[UpdatedOn]
	FROM [qan].[OsatAttributeTypeValues] AS V WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[OsatAttributeTypes] AS A WITH (NOLOCK) ON (A.[Id] = V.[AttributeTypeId])
	WHERE (@Id IS NULL OR V.[Id] = @Id)
	  AND (@AttributeTypeName IS NULL OR A.[Name] = @AttributeTypeName)
	  AND (@AttributeTypeId IS NULL OR V.[AttributeTypeId] = @AttributeTypeId)
	  AND (@Value IS NULL OR V.[Value] = @Value)
)
