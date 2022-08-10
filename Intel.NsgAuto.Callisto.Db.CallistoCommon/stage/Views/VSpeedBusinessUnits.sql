CREATE VIEW [stage].[VSpeedBusinessUnits]
	AS SELECT DISTINCT [BusinessUnitId] AS [Id], [BusinessUnitNm] AS [Name] FROM [stage].[ItemDetailV2] WITH (NOLOCK) WHERE NULLIF(LTRIM(RTRIM([BusinessUnitId])), '') IS NOT NULL OR NULLIF(LTRIM(RTRIM([BusinessUnitNm])), '') IS NOT NULL;
