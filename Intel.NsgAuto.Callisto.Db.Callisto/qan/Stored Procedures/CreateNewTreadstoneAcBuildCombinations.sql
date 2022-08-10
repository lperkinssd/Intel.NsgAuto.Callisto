-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-29 13:12:18.647
-- Description  : Creates new auto checker build combinations from the treadstone data
-- Example      : EXEC [qan].[CreateNewTreadstoneAcBuildCombinations];
-- ======================================================================================
CREATE PROCEDURE [qan].[CreateNewTreadstoneAcBuildCombinations]
(
	  @CountInserted INT = NULL OUTPUT
	, @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);

	IF (@By IS NULL) SET @By = [qan].[CreatedByTreadstone]();

	MERGE [qan].[AcBuildCombinations] AS M
	USING
	(
		SELECT DISTINCT [qan].[FCreateAcBuildCombinationName](P.[Name], FF.[Name], TF.[Name], PC.[Name]) AS [Name], P.[Id] AS [DesignId], FF.[Id] AS [FabricationFacilityId], TF.[Id] AS [TestFlowId], PC.[Id] AS [ProbeConversionId] FROM
		(
		 SELECT DISTINCT UPPER(NULLIF(LTRIM(RTRIM([design_id])), '')) AS [DesignName], UPPER(NULLIF(LTRIM(RTRIM([fabrication_facility])), '')) AS [FabricationFacilityName], UPPER(NULLIF(LTRIM(RTRIM([test_flow])), '')) AS [TestFlowName], UPPER(NULLIF(LTRIM(RTRIM([prb_conv_id])), '')) AS [ProbeConversionName] FROM [TREADSTONE].[treadstone].[dbo].[build_rule] WITH (NOLOCK) WHERE NULLIF(LTRIM(RTRIM([design_id])), '') IS NOT NULL AND NULLIF(LTRIM(RTRIM([fabrication_facility])), '') IS NOT NULL
		) AS S
		LEFT OUTER JOIN [qan].[Products] AS P WITH (NOLOCK) ON (P.[Name] = S.[DesignName])
		LEFT OUTER JOIN [qan].[FabricationFacilities] AS FF WITH (NOLOCK) ON (FF.[Name] = S.[FabricationFacilityName])
		LEFT OUTER JOIN [qan].[TestFlows] AS TF WITH (NOLOCK) ON (TF.[Name] = S.[TestFlowName])
		LEFT OUTER JOIN [qan].[ProbeConversions] AS PC WITH (NOLOCK) ON (PC.[Name] = S.[ProbeConversionName])
	) AS N
	ON
	(
			M.[DesignId] = N.[DesignId]
		AND M.[FabricationFacilityId] = N.[FabricationFacilityId]
		AND (M.[TestFlowId] = N.[TestFlowId] OR (M.[TestFlowId] IS NULL AND N.[TestFlowId] IS NULL))
		AND (M.[ProbeConversionId] = N.[ProbeConversionId] OR (M.[ProbeConversionId] IS NULL AND N.[ProbeConversionId] IS NULL))
	)
	WHEN NOT MATCHED THEN INSERT ([Name], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], N.[DesignId], N.[FabricationFacilityId], N.[TestFlowId], N.[ProbeConversionId], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @CountInserted = COUNT(*) FROM @Ids;

END