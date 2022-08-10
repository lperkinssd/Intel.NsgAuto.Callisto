-- =========================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-28 12:04:21.090
-- Description  : Compares records from the two tables passed in by joining on BuildCombinationId, AttributeTypeId, and
--                BuildCombinationId and listing the differences
-- Example      : DECLARE @Records1 [qan].[IAcBuildCriteriaConditionsCompare];
--                DECLARE @Records2 [qan].[IAcBuildCriteriaConditionsCompare];
--                INSERT INTO @Records1 ([BuildCombinationId], [AttributeTypeId], [ComparisonOperationId], [Id], [Value])
--                SELECT BC.[BuildCombinationId], BCC.[AttributeTypeId], BCC.[ComparisonOperationId], BCC.[Id], BCC.[Value] FROM [qan].[AcBuildCriteriaConditions] AS BCC WITH (NOLOCK) INNER JOIN [qan].[AcBuildCriterias] AS BC WITH (NOLOCK) ON (BC.[Id] = BCC.[BuildCriteriaId]) WHERE BC.[Id] = 1;
--                INSERT INTO @Records2 ([BuildCombinationId], [AttributeTypeId], [ComparisonOperationId], [Id], [Value])
--                SELECT [BuildCombinationId], [AttributeTypeId], [ComparisonOperationId], [Id], [Value] FROM @Records1;
--                UPDATE TOP (1) @Records2 SET [Value] = 'TEST';
--                SELECT * FROM [qan].[FCompareAcBuildCriteriaConditionFields](@Records1, @Records2) WHERE [Different] = 1;
-- =========================================================================================================================
CREATE FUNCTION [qan].[FCompareAcBuildCriteriaConditionFields]
(
	  @Records1 [qan].[IAcBuildCriteriaConditionsCompare] READONLY
	, @Records2 [qan].[IAcBuildCriteriaConditionsCompare] READONLY
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
		, [AttributeTypeId] = ISNULL(R1.[AttributeTypeId], R2.[AttributeTypeId])
		, [ComparisonOperationId] = ISNULL(R1.[ComparisonOperationId], R2.[ComparisonOperationId])
		, [MissingFrom] = CAST(CASE WHEN (R1.[BuildCombinationId] = R2.[BuildCombinationId]) OR (R1.[BuildCombinationId] IS NULL AND R2.[BuildCombinationId] IS NULL) THEN NULL WHEN (R1.[BuildCombinationId] IS NULL) THEN 1 ELSE 2 END AS TINYINT)
		, [Id1] = R1.[Id]
		, [Id2] = R2.[Id]
		, CA.[Field]
		, CA.[Different]
		, CA.[Value1]
		, CA.[Value2]
	FROM R1 FULL OUTER JOIN R2 ON (R1.[BuildCombinationId] = R2.[BuildCombinationId] AND R1.[AttributeTypeId] = R2.[AttributeTypeId] AND R1.[ComparisonOperationId] = R2.[ComparisonOperationId])
	CROSS APPLY
	(
		VALUES
		  (
			  'Value'
			, CAST(CASE WHEN (R1.[Value] = R2.[Value]) OR (R1.[Value] IS NULL AND R2.[Value] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, R1.[Value]
			, R2.[Value]
		  )
	) AS CA([Field], [Different], [Value1], [Value2])
)
