-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-03 13:23:08.600
-- Description  : Compares records from the two tables passed in by joining on [BuildCombinationId] and
--                listing the differences
-- =====================================================================================================
CREATE FUNCTION [qan].[FCompareOsatBuildCriteriaSetFields]
(
	  @Records1 [qan].[IOsatBuildCriteriaSetsCompare] READONLY
	, @Records2 [qan].[IOsatBuildCriteriaSetsCompare] READONLY
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
			  'EffectiveOn'
			, CAST(CASE WHEN (R1.[EffectiveOn] = R2.[EffectiveOn]) OR (R1.[EffectiveOn] IS NULL AND R2.[EffectiveOn] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[EffectiveOn] AS VARCHAR(MAX))
			, CAST(R2.[EffectiveOn] AS VARCHAR(MAX))
		  )
	) AS CA([Field], [Different], [Value1], [Value2])

)
