-- ===========================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-12 09:43:13.563
-- Description  : Gets attribute data type operations
-- Example      : SELECT * FROM [qan].[FAcComparisonOperations](NULL, NULL, NULL, NULL, NULL);
-- ===========================================================================================
CREATE FUNCTION [qan].[FAcComparisonOperations]
(
	  @Id            BIGINT = NULL
	, @Key           VARCHAR(25) = NULL
	, @NoDataType    BIT = NULL
	, @DataTypeId    INT = NULL
	, @OperandTypeId INT = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  O.[Id]
		, O.[Key]
		, O.[KeyTreadstone]
		, O.[Name]
		, O.[OperandTypeId]
		, OT.[Name] AS [OperandTypeName]
	FROM [ref].[AcComparisonOperations] AS O WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[AcOperandTypes] AS OT WITH (NOLOCK) ON (OT.[Id] = O.[OperandTypeId])
	WHERE (@Id IS NULL OR O.[Id] = @Id)
	  AND (@Key IS NULL OR O.[Name] = @Key)
	  AND (@NoDataType IS NULL OR (@NoDataType = 0 AND EXISTS(SELECT 1 FROM [ref].[AcAttributeDataTypeOperations] WITH (NOLOCK) WHERE [ComparisonOperationId] = O.[Id])) OR (@NoDataType = 1 AND NOT EXISTS(SELECT 1 FROM [ref].[AcAttributeDataTypeOperations] WITH (NOLOCK) WHERE [ComparisonOperationId] = O.[Id])))
	  AND (@DataTypeId IS NULL OR O.[Id] IN (SELECT [ComparisonOperationId] FROM [ref].[AcAttributeDataTypeOperations] WITH (NOLOCK) WHERE [AttributeDataTypeId] = @DataTypeId))
	  AND (@OperandTypeId IS NULL OR O.[OperandTypeId] = @OperandTypeId)
)
