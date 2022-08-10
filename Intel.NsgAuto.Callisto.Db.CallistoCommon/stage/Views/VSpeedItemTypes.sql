CREATE VIEW [stage].[VSpeedItemTypes]
	AS SELECT DISTINCT [ItemTypeCd] AS [Code], [ItemClassDsc] AS [Name] FROM [stage].[BillOfMaterialExplosionDetailV2] WITH (NOLOCK) WHERE NULLIF(LTRIM(RTRIM([ItemTypeCd])), '') IS NOT NULL OR NULLIF(LTRIM(RTRIM([ItemClassDsc])), '') IS NOT NULL;
