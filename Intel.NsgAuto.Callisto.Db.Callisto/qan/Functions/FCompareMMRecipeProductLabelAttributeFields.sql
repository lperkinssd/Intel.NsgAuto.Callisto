-- ==============================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-15 16:25:59.027
-- Description  : Compares records from the two tables passed in by joining on PCode and listing the differences
-- Example      : DECLARE @Records1 [qan].[IMMRecipeProductLabelAttributesCompare];
--                DECLARE @Records2 [qan].[IMMRecipeProductLabelAttributesCompare];
--                DECLARE @PCode VARCHAR(10) = '000000';
--                INSERT INTO @Records1 ([PCode], [AttributeTypeId], [Id], [Value])
--                SELECT @PCode, [AttributeTypeId], [Id], [Value] FROM [qan].[ProductLabelAttributes] WITH (NOLOCK) WHERE [ProductLabelId] = 6;
--                INSERT INTO @Records2 ([PCode], [AttributeTypeId], [Id], [Value])
--                SELECT @PCode, [AttributeTypeId], [Id], [Value] FROM [qan].[ProductLabelAttributes] WITH (NOLOCK) WHERE [ProductLabelId] = 7;
--                SELECT * FROM [qan].[FCompareMMRecipeProductLabelAttributeFields](@Records1, @Records2);
-- ==============================================================================================================
CREATE FUNCTION [qan].[FCompareMMRecipeProductLabelAttributeFields]
(
	  @Records1 [qan].[IMMRecipeProductLabelAttributesCompare] READONLY
	, @Records2 [qan].[IMMRecipeProductLabelAttributesCompare] READONLY
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
		, [AttributeTypeId] = ISNULL(R1.[AttributeTypeId], R2.[AttributeTypeId])
		, [MissingFrom] = CAST(CASE WHEN (R1.[AttributeTypeId] = R2.[AttributeTypeId]) OR (R1.[AttributeTypeId] IS NULL AND R2.[AttributeTypeId] IS NULL) THEN NULL WHEN (R1.[AttributeTypeId] IS NULL) THEN 1 ELSE 2 END AS TINYINT)
		, [Id1] = R1.[Id]
		, [Id2] = R2.[Id]
		, CA.[Field]
		, CA.[Different]
		, CA.[Value1]
		, CA.[Value2]
	FROM R1 FULL OUTER JOIN R2 ON (R1.[PCode] = R2.[PCode] AND R1.[AttributeTypeId] = R2.[AttributeTypeId])
	CROSS APPLY
	(
		VALUES
		  (
			  'Value'
			, CAST(CASE WHEN (R1.[Value] = R2.[Value]) OR (R1.[Value] IS NULL AND R2.[Value] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[Value] AS VARCHAR(MAX))
			, CAST(R2.[Value] AS VARCHAR(MAX))
		  )
	) AS CA([Field], [Different], [Value1], [Value2])

)
