-- ==============================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-15 16:25:59.027
-- Description  : Compares records from the two tables passed in by joining on PCode and listing the differences
-- Example      : DECLARE @Records1 [qan].[IMMRecipeMATAttributeValuesCompare];
--                DECLARE @Records2 [qan].[IMMRecipeMATAttributeValuesCompare];
--                DECLARE @PCode VARCHAR(10) = '000000';
--                DECLARE @AssociatedItemId VARCHAR(10) = 'K00000-000';
--                INSERT INTO @Records1 ([Id], [PCode], [AssociatedItemId], [AttributeTypeId], [Value], [Operator], [DataType])
--                SELECT [Id], @PCode, @AssociatedItemId, [AttributeTypeId], [Value], [Operator], [DataType] FROM [qan].[MATAttributeValues] WITH (NOLOCK) WHERE [MATId] = 1;
--                INSERT INTO @Records2 ([Id], [PCode], [AssociatedItemId], [AttributeTypeId], [Value], [Operator], [DataType])
--                SELECT [Id], @PCode, @AssociatedItemId, [AttributeTypeId], [Value], [Operator], [DataType] FROM [qan].[MATAttributeValues] WITH (NOLOCK) WHERE [MATId] = 2;
--                SELECT * FROM [qan].[FCompareMMRecipeMATAttributeValues](@Records1, @Records2);
-- ==============================================================================================================
CREATE FUNCTION [qan].[FCompareMMRecipeMATAttributeValues]
(
	  @Records1 [qan].[IMMRecipeMATAttributeValuesCompare] READONLY
	, @Records2 [qan].[IMMRecipeMATAttributeValuesCompare] READONLY
)
RETURNS TABLE AS RETURN
(

	WITH
	  R1 AS
	(
		SELECT * FROM @Records1
	)
	, R2 AS
	(
		SELECT * FROM @Records2
	)
	SELECT
		  [PCode] = ISNULL(R1.[PCode], R2.[PCode])
		, [AssociatedItemId] = ISNULL(R1.[AssociatedItemId], R2.[AssociatedItemId])
		, [AttributeTypeId] = ISNULL(R1.[AttributeTypeId], R2.[AttributeTypeId])
		, [Value] = ISNULL(R1.[Value], R2.[Value])
		, [Operator] = ISNULL(R1.[Operator], R2.[Operator])
		, [DataType] = ISNULL(R1.[DataType], R2.[DataType])
		, [MissingFrom] = CAST(CASE WHEN (R1.[PCode] = R2.[PCode]) OR (R1.[PCode] IS NULL AND R2.[PCode] IS NULL) THEN NULL WHEN (R1.[PCode] IS NULL) THEN 1 ELSE 2 END AS TINYINT)
		, [Id1] = R1.[Id]
		, [Id2] = R2.[Id]
	FROM R1 FULL OUTER JOIN R2 ON (R1.[PCode] = R2.[PCode] AND R1.[AttributeTypeId] = R2.[AttributeTypeId] AND ISNULL(R1.[Value], '') = ISNULL(R2.[Value], '') AND ISNULL(R1.[Operator], '') = ISNULL(R2.[Operator], '') AND ISNULL(R1.[DataType], '') = ISNULL(R2.[DataType], ''))

)
