CREATE VIEW [stage].[VSpeedCommodities]
	AS SELECT DISTINCT [CommodityCd] AS [Code], [CommodityCodeDsc] AS [Name] FROM [stage].[BillOfMaterialExplosionDetailV2] WITH (NOLOCK) WHERE NULLIF(LTRIM(RTRIM([CommodityCd])), '') IS NOT NULL OR NULLIF(LTRIM(RTRIM([CommodityCodeDsc])), '') IS NOT NULL;
