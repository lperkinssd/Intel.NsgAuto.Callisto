CREATE VIEW [stage].[VSpeedBomStructureTypes]
	AS SELECT DISTINCT [BillOfMaterialStructureTypeNm] AS [Name] FROM [stage].[BillOfMaterialExplosionDetailV2] WITH (NOLOCK) WHERE NULLIF(LTRIM(RTRIM([BillOfMaterialStructureTypeNm])), '') IS NOT NULL;
