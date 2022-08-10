CREATE VIEW [stage].[VSpeedMaterialTypes]
	AS SELECT DISTINCT [MaterialTypeCd] AS [Code] FROM [stage].[ItemDetailV2] WITH (NOLOCK) WHERE NULLIF(LTRIM(RTRIM([MaterialTypeCd])), '') IS NOT NULL;
