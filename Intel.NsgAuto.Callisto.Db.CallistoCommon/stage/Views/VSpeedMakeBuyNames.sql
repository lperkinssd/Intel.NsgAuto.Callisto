CREATE VIEW [stage].[VSpeedMakeBuyNames]
	AS SELECT DISTINCT [MakeBuyNm] AS [Name] FROM [stage].[ItemDetailV2] WITH (NOLOCK) WHERE NULLIF(LTRIM(RTRIM([MakeBuyNm])), '') IS NOT NULL;
