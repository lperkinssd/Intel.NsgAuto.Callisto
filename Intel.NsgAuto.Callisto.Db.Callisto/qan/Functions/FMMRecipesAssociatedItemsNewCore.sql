-- ==========================================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-21 19:44:31.890
-- Description  : Generates the core associated items part of new MM recipes for the given PCodes
-- Example      : DECLARE @PCodes [qan].[IPCodes];
--                INSERT INTO @PCodes SELECT TOP 5 [PCode] FROM [CallistoCommon].[stage].[PCodes] WITH (NOLOCK) WHERE [IncludeMMRecipes] = 1;
--                SELECT * FROM [qan].[FMMRecipesAssociatedItemsNewCore](@PCodes);
-- ==========================================================================================================================================
CREATE FUNCTION [qan].[FMMRecipesAssociatedItemsNewCore]
(
	@PCodes [qan].[IPCodes] READONLY
)
RETURNS TABLE AS RETURN
(
	SELECT
		  P.[PCode]
		, MM.[SCode]
		, M.[Id] AS [MATId]
		, C.[Id] AS [SpeedItemCategoryId]
		, C.[Name] AS [SpeedItemCategoryName]
		, I.[ItemCategory] AS [SpeedItemCategoryCode]
		, I.[ItemId]
		, I.[Revision]
		, A.[Id] AS [SpeedBomAssociationTypeId]
		, A.[Name] AS [SpeedBomAssociationTypeName]
		, I.[AssociationType] AS [SpeedBomAssociationTypeNameSpeed]
		, A.[CodeSpeed] AS [SpeedBomAssociationTypeCodeSpeed]
	FROM @PCodes AS P
	INNER JOIN [CallistoCommon].[stage].[SpeedMMRecipeItems] AS I WITH (NOLOCK) ON (I.[RootItemId] = P.[PCode])
	INNER JOIN [CallistoCommon].[stage].[SpeedMMRecipes] AS MM WITH (NOLOCK) ON (MM.[RootItemId] = I.[RootItemId])
	LEFT OUTER JOIN [ref].[SpeedItemCategories] AS C WITH (NOLOCK) ON (C.[Code] = I.[ItemCategory])
	LEFT OUTER JOIN [qan].[SpeedBomAssociationTypes] AS A WITH (NOLOCK) ON (A.[NameSpeed] = I.[AssociationType])
	LEFT OUTER JOIN [qan].[MATVersions] AS MV WITH (NOLOCK) ON (MV.[IsPOR] = 1)
	LEFT OUTER JOIN [qan].[MATs] AS M WITH (NOLOCK) ON (M.[MATVersionId] = MV.[Id] AND M.[SCode] = MM.[SCode] AND M.[MediaIPN] = I.[ItemId] AND I.[ItemCategory] = 'NAND_MEDIA')
	WHERE I.[ItemCategory] IN ('NAND_MEDIA', 'TA', 'SA', 'PBA', 'AA', 'FIRMWARE')
)
