-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-16 16:58:51.737
-- Description  : Gets auto checker build criteria template conditions
-- Example      : SELECT * FROM [qan].[FAcBuildCriteriaTemplateConditions](NULL, 1, NULL, NULL, NULL, NULL, NULL);
-- ===============================================================================================================
CREATE FUNCTION [qan].[FAcBuildCriteriaTemplateConditions]
(
	  @Id INT = NULL
	, @TemplateId INT = NULL
	, @AttributeTypeId INT = NULL
	, @AttributeTypeName VARCHAR(50) = NULL
	, @ComparisonOperationId INT = NULL
	, @ComparisonOperationKey VARCHAR(25) = NULL
	, @Value VARCHAR(MAX) = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  C.[Id]
		, C.[TemplateId]
		, C.[AttributeTypeId]
		, A.[Name] AS [AttributeTypeName]
		, A.[NameDisplay] AS [AttributeTypeNameDisplay]
		, A.[DataTypeId] AS [AttributeTypeDataTypeId]
		, D.[Name] AS [AttributeTypeDataTypeName]
		, D.[NameDisplay] AS [AttributeTypeDataTypeNameDisplay]
		, A.[CreatedBy] AS [AttributeTypeCreatedBy]
		, A.[CreatedOn] AS [AttributeTypeCreatedOn]
		, A.[UpdatedBy] AS [AttributeTypeUpdatedBy]
		, A.[UpdatedOn] AS [AttributeTypeUpdatedOn]
		, C.[ComparisonOperationId]
		, O.[Key] AS [ComparisonOperationKey]
		, O.[KeyTreadstone] AS [ComparisonOperationKeyTreadstone]
		, O.[Name] AS [ComparisonOperationName]
		, O.[OperandTypeId] AS [ComparisonOperationOperandTypeId]
		, OT.[Name] AS [ComparisonOperationOperandTypeName]
		, C.[Value]
	FROM [qan].[AcBuildCriteriaTemplateConditions] AS C WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[AcAttributeTypes] AS A WITH (NOLOCK) ON (A.[Id] = C.[AttributeTypeId])
	LEFT OUTER JOIN [ref].[AcAttributeDataTypes] AS D WITH (NOLOCK) ON (D.[Id] = A.[DataTypeId])
	LEFT OUTER JOIN [ref].[AcComparisonOperations] AS O WITH (NOLOCK) ON (O.[Id] = C.[ComparisonOperationId])
	LEFT OUTER JOIN [ref].[AcOperandTypes] AS OT WITH (NOLOCK) ON (OT.[Id] = O.[OperandTypeId])
	WHERE (@Id IS NULL OR C.[Id] = @Id)
	  AND (@TemplateId IS NULL OR C.[TemplateId] = @TemplateId)
	  AND (@AttributeTypeId IS NULL OR C.[AttributeTypeId] = @AttributeTypeId)
	  AND (@AttributeTypeName IS NULL OR A.[Name] = @AttributeTypeName)
	  AND (@ComparisonOperationId IS NULL OR C.[ComparisonOperationId] = @ComparisonOperationId)
	  AND (@ComparisonOperationKey IS NULL OR O.[Key] = @ComparisonOperationKey)
	  AND (@Value IS NULL OR C.[Value] = @Value)
)
