-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-11 13:56:27.657
-- Description  : Gets auto checker build criteria review groups with no decision
-- Example      : SELECT * FROM [qan].[FAcBuildCriteriaReviewGroupsNoDecision](1);
-- =================================================================================
CREATE FUNCTION [qan].[FAcBuildCriteriaReviewGroupsNoDecision]
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
	FROM [qan].[AcBuildCriteriaReviewGroups] AS G WITH (NOLOCK)
	WHERE G.[VersionId] = @VersionId
	AND G.[ReviewGroupId] IN
	(
		SELECT [ReviewGroupId] FROM
		(
			-- innermost query gets all review stage and group combinations that do not have any decisions
			SELECT DISTINCT [ReviewStageId], [ReviewGroupId] FROM [qan].[AcBuildCriteriaReviewGroups] WITH (NOLOCK) WHERE [VersionId] = @VersionId
			EXCEPT
			SELECT DISTINCT [ReviewStageId], [ReviewGroupId] FROM [qan].[AcBuildCriteriaReviewDecisions] WITH (NOLOCK) WHERE [VersionId] = @VersionId
		) AS T
	)
)
