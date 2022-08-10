-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16
-- Description  : Gets osat build criteria set review groups with no decision
-- Example      : SELECT * FROM [qan].[FOsatBuildCriteriaSetReviewGroupsNoDecision](1);
-- ======================================================================================
CREATE FUNCTION [qan].[FOsatBuildCriteriaSetReviewGroupsNoDecision]
(
	  @VersionId BIGINT
)
RETURNS TABLE AS RETURN
(
	SELECT
		  G.[Id]
		, G.[VersionId]
		, G.[ReviewStageId]
		, G.[ReviewGroupId]
		, G.[GroupName]
		, G.[DisplayName]
	FROM [qan].[OsatBuildCriteriaSetReviewGroups] AS G WITH (NOLOCK)
	WHERE G.[VersionId] = @VersionId
	AND G.[ReviewGroupId] IN
	(
		SELECT [ReviewGroupId] FROM
		(
			-- innermost query gets all review stage and group combinations that do not have any decisions
			SELECT DISTINCT [ReviewStageId], [ReviewGroupId] FROM [qan].[OsatBuildCriteriaSetReviewGroups] WITH (NOLOCK) WHERE [VersionId] = @VersionId
			EXCEPT
			SELECT DISTINCT [ReviewStageId], [ReviewGroupId] FROM [qan].[OsatBuildCriteriaSetReviewDecisions] WITH (NOLOCK) WHERE [VersionId] = @VersionId
		) AS T
	)
)
