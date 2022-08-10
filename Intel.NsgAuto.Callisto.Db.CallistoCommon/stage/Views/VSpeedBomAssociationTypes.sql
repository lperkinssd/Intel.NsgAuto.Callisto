CREATE VIEW [stage].[VSpeedBomAssociationTypes]
	AS SELECT DISTINCT [BillOfMaterialTypeCd] AS [Code], [BillOfMaterialAssociationTypeNm] AS [Name] FROM [stage].[BillOfMaterialExplosionDetailV2] WITH (NOLOCK) WHERE NULLIF(LTRIM(RTRIM([BillOfMaterialTypeCd])), '') IS NOT NULL OR NULLIF(LTRIM(RTRIM([BillOfMaterialAssociationTypeNm])), '') IS NOT NULL;
