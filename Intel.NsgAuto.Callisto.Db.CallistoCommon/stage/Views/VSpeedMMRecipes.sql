-- =========================================================================
-- Author       : bricschx
-- Create date  : 2020-11-03 10:03:59.870
-- Description  : This view contains the important logic for mapping speed
--                data to mm recipe fields. This view is refreshed to the
--                table SpeedMMRecipes for performance reasons as part of
--                the Speed pull post processing steps.
-- =========================================================================
CREATE VIEW [stage].[VSpeedMMRecipes]
AS  SELECT
		  I_P.[RootItemId] AS [RootItemId]
		, I_P.[MaxItemId] As [PCode]
		, I_P.[MaxRevision] AS [PCodeRevision]
		, I_S.[MaxItemId] As [SCode]
		, I_S.[MaxRevision] AS [SCodeRevision]
		, P.[BdCategoryType] + ' ' + P.[MemoryAmount1] + ' ' + P.[BusArchitecture] + ' ' + P.[FormFactor] AS [ProductName]
		, P.[MarketCodeName] AS [ProductFamily]
		, P.[ItemMarketName] AS [ProductionProductCode]
		, P.[ModelStringName] AS [ModelString]
		, P.[FormFactor] AS [FormFactorName]
		, P.[CustomerCustomProduct] AS [CustomerName]
		, S.[ModelStringName] AS [SCodeProductCode] -- it seems like this should actually be S.[ItemMarketName] to be consistent with pcodes
	FROM [stage].[VSpeedMMRecipeItemsGbCategory] AS I_P WITH (NOLOCK)
	LEFT OUTER JOIN [stage].[VSpeedMMRecipeItemsGbCategory] AS I_S WITH (NOLOCK) ON (I_S.[RootItemId] = I_P.[RootItemId] AND I_S.[ItemCategory] = 'SCODE')
	LEFT OUTER JOIN [stage].[SpeedPCodeItems] AS P WITH (NOLOCK) ON (P.[ItemId] = I_P.[MaxItemId])
	LEFT OUTER JOIN [stage].[SpeedSCodeItems] AS S WITH (NOLOCK) ON (S.[ItemId] = I_S.[MaxItemId])
	WHERE I_P.[ItemCategory] = 'PCODE'
