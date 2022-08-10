-- ===================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-30 12:35:28.733
-- Description  : Compares records from the two tables passed in by joining on BuildCombinationId and
--                listing the differences
-- Example      : DECLARE @Records1 [qan].[IAcBuildCriteriasCompare];
--                DECLARE @Records2 [qan].[IAcBuildCriteriasCompare];
--                INSERT INTO @Records1 ([Id], [BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId], [EffectiveOn])
--                SELECT [Id], [BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId], [EffectiveOn] FROM [qan].[AcBuildCriterias] WITH (NOLOCK) WHERE [Id] = 1;
--                INSERT INTO @Records2 ([Id], [BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId], [EffectiveOn])
--                SELECT [Id], [BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId], [EffectiveOn] FROM @Records1;
--                UPDATE @Records2 SET [EffectiveOn] = GETUTCDATE();
--                SELECT * FROM [qan].[FCompareAcBuildCriteriaFields](@Records1, @Records2);
-- ===================================================================================================
CREATE FUNCTION [qan].[FCompareAcBuildCriteriaFields]
(
	  @Records1 [qan].[IAcBuildCriteriasCompare] READONLY
	, @Records2 [qan].[IAcBuildCriteriasCompare] READONLY
)
RETURNS TABLE AS RETURN
(

	WITH
	  R1 AS
	(
		SELECT * FROM @Records1
	)
	, R2 AS
	(
		SELECT * FROM @Records2
	)
	SELECT
		  [BuildCombinationId] = ISNULL(R1.[BuildCombinationId], R2.[BuildCombinationId])
		, [MissingFrom] = CAST(CASE WHEN (R1.[BuildCombinationId] = R2.[BuildCombinationId]) OR (R1.[BuildCombinationId] IS NULL AND R2.[BuildCombinationId] IS NULL) THEN NULL WHEN (R1.[BuildCombinationId] IS NULL) THEN 1 ELSE 2 END AS TINYINT)
		, [Id1] = R1.[Id]
		, [Id2] = R2.[Id]
		, CA.[Field]
		, CA.[Different]
		, CA.[Value1]
		, CA.[Value2]
	FROM R1 FULL OUTER JOIN R2 ON (R1.[BuildCombinationId] = R2.[BuildCombinationId])
	CROSS APPLY
	(
		VALUES
		  (
			  'DesignId'
			, CAST(CASE WHEN (R1.[DesignId] = R2.[DesignId]) OR (R1.[DesignId] IS NULL AND R2.[DesignId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[DesignId] AS VARCHAR(MAX))
			, CAST(R2.[DesignId] AS VARCHAR(MAX))
		  )
		, (
			  'FabricationFacilityId'
			, CAST(CASE WHEN (R1.[FabricationFacilityId] = R2.[FabricationFacilityId]) OR (R1.[FabricationFacilityId] IS NULL AND R2.[FabricationFacilityId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[FabricationFacilityId] AS VARCHAR(MAX))
			, CAST(R2.[FabricationFacilityId] AS VARCHAR(MAX))
		  )
		, (
			  'TestFlowId'
			, CAST(CASE WHEN (R1.[TestFlowId] = R2.[TestFlowId]) OR (R1.[TestFlowId] IS NULL AND R2.[TestFlowId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[TestFlowId] AS VARCHAR(MAX))
			, CAST(R2.[TestFlowId] AS VARCHAR(MAX))
		  )
		, (
			  'ProbeConversionId'
			, CAST(CASE WHEN (R1.[ProbeConversionId] = R2.[ProbeConversionId]) OR (R1.[ProbeConversionId] IS NULL AND R2.[ProbeConversionId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[ProbeConversionId] AS VARCHAR(MAX))
			, CAST(R2.[ProbeConversionId] AS VARCHAR(MAX))
		  )
		, (
			  'EffectiveOn'
			, CAST(CASE WHEN (R1.[EffectiveOn] = R2.[EffectiveOn]) OR (R1.[EffectiveOn] IS NULL AND R2.[EffectiveOn] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[EffectiveOn] AS VARCHAR(MAX))
			, CAST(R2.[EffectiveOn] AS VARCHAR(MAX))
		  )
	) AS CA([Field], [Different], [Value1], [Value2])

)
