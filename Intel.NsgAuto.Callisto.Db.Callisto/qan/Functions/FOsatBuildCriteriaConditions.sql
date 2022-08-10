-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16
-- Description  : Gets osat build criteria conditions
-- Example      : SELECT * FROM [qan].[FOsatBuildCriteriaConditions](NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL);
-- ===============================================================================================================
CREATE FUNCTION [qan].[FOsatBuildCriteriaConditions]
(
	  @Id                      BIGINT        = NULL
	, @BuildCriteriaSetId      BIGINT        = NULL
	, @BuildCriteriaId         BIGINT        = NULL
	, @AttributeTypeId         INT           = NULL
	, @AttributeTypeName       VARCHAR(50)   = NULL
	, @ComparisonOperationId   INT           = NULL
	, @ComparisonOperationKey  VARCHAR(25)   = NULL
	, @Value                   VARCHAR(4000) = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  C.[Id]
		, BC.[BuildCriteriaSetId]
		, C.[BuildCriteriaId]
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
		, O.[Name] AS [ComparisonOperationName]
		, O.[OperandTypeId] AS [ComparisonOperationOperandTypeId]
		, OT.[Name] AS [ComparisonOperationOperandTypeName]
		, C.[Value]
		, C.[CreatedBy]
		, C.[CreatedOn]
		, C.[UpdatedBy]
		, C.[UpdatedOn]
	FROM [qan].[OsatBuildCriteriaConditions] AS C WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[OsatBuildCriterias] AS BC WITH (NOLOCK) ON (BC.[Id] = C.[BuildCriteriaId])
	LEFT OUTER JOIN [qan].[OsatAttributeTypes] AS A WITH (NOLOCK) ON (A.[Id] = C.[AttributeTypeId])
	LEFT OUTER JOIN [ref].[OsatAttributeDataTypes] AS D WITH (NOLOCK) ON (D.[Id] = A.[DataTypeId])
	LEFT OUTER JOIN [ref].[OsatComparisonOperations] AS O WITH (NOLOCK) ON (O.[Id] = C.[ComparisonOperationId])
	LEFT OUTER JOIN [ref].[OsatOperandTypes] AS OT WITH (NOLOCK) ON (OT.[Id] = O.[OperandTypeId])
	WHERE (@Id IS NULL OR C.[Id] = @Id)
	  AND (@BuildCriteriaSetId IS NULL OR BC.[BuildCriteriaSetId] = @BuildCriteriaSetId)
	  AND (@BuildCriteriaId IS NULL OR C.[BuildCriteriaId] = @BuildCriteriaId)
	  AND (@AttributeTypeId IS NULL OR C.[AttributeTypeId] = @AttributeTypeId)
	  AND (@AttributeTypeName IS NULL OR A.[Name] = @AttributeTypeName)
	  AND (@ComparisonOperationId IS NULL OR C.[ComparisonOperationId] = @ComparisonOperationId)
	  AND (@ComparisonOperationKey IS NULL OR O.[Key] = @ComparisonOperationKey)
	  AND (@Value IS NULL OR C.[Value] = @Value)
)
