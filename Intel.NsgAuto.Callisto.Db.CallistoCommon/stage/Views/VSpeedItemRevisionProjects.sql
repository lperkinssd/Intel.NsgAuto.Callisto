CREATE VIEW [stage].[VSpeedItemRevisionProjects]
	AS SELECT DISTINCT [ItemRevisionProjectCd] AS [Code] FROM [stage].[BillOfMaterialExplosionDetailV2] WITH (NOLOCK) WHERE NULLIF(LTRIM(RTRIM([ItemRevisionProjectCd])), '') IS NOT NULL;
