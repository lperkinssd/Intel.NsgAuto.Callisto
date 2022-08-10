CREATE VIEW [stage].[VSpeedReleaseStatuses]
	AS SELECT DISTINCT [ReleaseStatusCd] AS [Code], [ReleaseStatusNm] AS [Name] FROM [stage].[BillOfMaterialExplosionDetailV2] WITH (NOLOCK) WHERE NULLIF(LTRIM(RTRIM([ReleaseStatusCd])), '') IS NOT NULL OR NULLIF(LTRIM(RTRIM([ReleaseStatusNm])), '') IS NOT NULL;
