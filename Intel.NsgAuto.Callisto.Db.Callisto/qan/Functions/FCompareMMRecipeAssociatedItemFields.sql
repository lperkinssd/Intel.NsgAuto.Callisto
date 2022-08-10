-- ==============================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-15 16:25:59.027
-- Description  : Compares records from the two tables passed in by joining on PCode and listing the differences
-- Example      : DECLARE @Records1 [qan].[IMMRecipeAssociatedItemsCompare];
--                DECLARE @Records2 [qan].[IMMRecipeAssociatedItemsCompare];
--                DECLARE @PCode VARCHAR(10) = '000000';
--                INSERT INTO @Records1 ([PCode], [ItemId], [Id], [MATId], [SpeedItemCategoryId], [Revision], [SpeedBomAssociationTypeId])
--                SELECT @PCode, [ItemId], [Id], [MATId], [SpeedItemCategoryId], [Revision], [SpeedBomAssociationTypeId] FROM [qan].[MMRecipeAssociatedItems] WITH (NOLOCK) WHERE [MMRecipeId] = 1;
--                INSERT INTO @Records2 ([PCode], [ItemId], [Id], [MATId], [SpeedItemCategoryId], [Revision], [SpeedBomAssociationTypeId])
--                SELECT @PCode, [ItemId], [Id], [MATId], [SpeedItemCategoryId], '00', [SpeedBomAssociationTypeId] FROM [qan].[MMRecipeAssociatedItems] WITH (NOLOCK) WHERE [MMRecipeId] = 1;
--                SELECT * FROM [qan].[FCompareMMRecipeAssociatedItemFields](@Records1, @Records2);
-- ==============================================================================================================
CREATE FUNCTION [qan].[FCompareMMRecipeAssociatedItemFields]
(
	  @Records1 [qan].[IMMRecipeAssociatedItemsCompare] READONLY
	, @Records2 [qan].[IMMRecipeAssociatedItemsCompare] READONLY
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
		, [ItemId] = ISNULL(R1.[ItemId], R2.[ItemId])
		, [MissingFrom] = CAST(CASE WHEN (R1.[ItemId] = R2.[ItemId]) OR (R1.[ItemId] IS NULL AND R2.[ItemId] IS NULL) THEN NULL WHEN (R1.[ItemId] IS NULL) THEN 1 ELSE 2 END AS TINYINT)
		, [Id1] = R1.[Id]
		, [Id2] = R2.[Id]
		, CA.[Field]
		, CA.[Different]
		, CA.[Value1]
		, CA.[Value2]
	FROM R1 FULL OUTER JOIN R2 ON (R1.[PCode] = R2.[PCode] AND R1.[ItemId] = R2.[ItemId])
	CROSS APPLY
	(
		VALUES
		  (
			  'MATId'
			, CAST(CASE WHEN (R1.[MATId] = R2.[MATId]) OR (R1.[MATId] IS NULL AND R2.[MATId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[MATId] AS VARCHAR(MAX))
			, CAST(R2.[MATId] AS VARCHAR(MAX))
		  )
		, (
			  'SpeedItemCategoryId'
			, CAST(CASE WHEN (R1.[SpeedItemCategoryId] = R2.[SpeedItemCategoryId]) OR (R1.[SpeedItemCategoryId] IS NULL AND R2.[SpeedItemCategoryId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[SpeedItemCategoryId] AS VARCHAR(MAX))
			, CAST(R2.[SpeedItemCategoryId] AS VARCHAR(MAX))
		  )
		, (
			  'Revision'
			, CAST(CASE WHEN (R1.[Revision] = R2.[Revision]) OR (R1.[Revision] IS NULL AND R2.[Revision] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[Revision] AS VARCHAR(MAX))
			, CAST(R2.[Revision] AS VARCHAR(MAX))
		  )
		, (
			  'SpeedBomAssociationTypeId'
			, CAST(CASE WHEN (R1.[SpeedBomAssociationTypeId] = R2.[SpeedBomAssociationTypeId]) OR (R1.[SpeedBomAssociationTypeId] IS NULL AND R2.[SpeedBomAssociationTypeId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[SpeedBomAssociationTypeId] AS VARCHAR(MAX))
			, CAST(R2.[SpeedBomAssociationTypeId] AS VARCHAR(MAX))
		  )
	) AS CA([Field], [Different], [Value1], [Value2])

)
