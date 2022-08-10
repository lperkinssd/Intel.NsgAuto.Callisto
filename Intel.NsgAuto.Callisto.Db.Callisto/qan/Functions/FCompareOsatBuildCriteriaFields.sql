-- ========================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16
-- Description  : Compares records from the two tables passed in by joining on BuildCombinationId and Ordinal, and listing the differences
-- Example      : DECLARE @Records1 [qan].[IOsatBuildCriteriasCompare];
--                DECLARE @Records2 [qan].[IOsatBuildCriteriasCompare];
--                INSERT INTO @Records1 ([BuildCombinationId], [Ordinal], [Id], [Name])
--                SELECT S.[BuildCombinationId], BC.[Ordinal], BC.[Id], BC.[Name] FROM [qan].[OsatBuildCriterias] AS BC WITH (NOLOCK) INNER JOIN [qan].[OsatBuildCriteriaSets] AS S WITH (NOLOCK) ON (S.[Id] = BC.[BuildCriteriaSetId]) WHERE S.[Id] = 1;
--                INSERT INTO @Records2 ([BuildCombinationId], [Ordinal], [Id], [Name])
--                SELECT [BuildCombinationId], [Ordinal], [Id], [Name] FROM @Records1;
--                UPDATE TOP (1) @Records2 SET [Name] = 'TEST';
--                SELECT * FROM [qan].[FCompareOsatBuildCriteriaFields](@Records1, @Records2) WHERE [Different] = 1;
-- ========================================================================================================================================
CREATE FUNCTION [qan].[FCompareOsatBuildCriteriaFields]
(
	  @Records1 [qan].[IOsatBuildCriteriasCompare] READONLY
	, @Records2 [qan].[IOsatBuildCriteriasCompare] READONLY
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
		, [Ordinal] = ISNULL(R1.[Ordinal], R2.[Ordinal])
		, [MissingFrom] = CAST(CASE WHEN (R1.[BuildCombinationId] = R2.[BuildCombinationId]) OR (R1.[BuildCombinationId] IS NULL AND R2.[BuildCombinationId] IS NULL) THEN NULL WHEN (R1.[BuildCombinationId] IS NULL) THEN 1 ELSE 2 END AS TINYINT)
		, [Id1] = R1.[Id]
		, [Id2] = R2.[Id]
		, CA.[Field]
		, CA.[Different]
		, CA.[Value1]
		, CA.[Value2]
	FROM R1 FULL OUTER JOIN R2 ON (R1.[BuildCombinationId] = R2.[BuildCombinationId] AND R1.[Ordinal] = R2.[Ordinal])
	CROSS APPLY
	(
		VALUES
		  (
			  'Name'
			, CAST(CASE WHEN (R1.[Name] = R2.[Name]) OR (R1.[Name] IS NULL AND R2.[Name] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, R1.[Name]
			, R2.[Name]
		  )
	) AS CA([Field], [Different], [Value1], [Value2])
)
