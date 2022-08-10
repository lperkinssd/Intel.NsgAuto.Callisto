-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16
-- Description  : Gets osat build criteria set review stages
-- Example      : SELECT * FROM [qan].[FOsatBuildCriteriaSetReviewGroups](NULL, NULL, NULL, NULL, NULL);
-- =====================================================================================================
CREATE FUNCTION [qan].[FOsatBuildCriteriaSetReviewGroups]
(
	  @Id             BIGINT      = NULL
	, @VersionId      BIGINT      = NULL
	, @ReviewStageId  INT         = NULL
	, @ReviewGroupId  INT         = NULL
	, @GroupName      VARCHAR(50) = NULL
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
	WHERE (@Id IS NULL OR G.[Id] = @Id)
	  AND (@VersionId IS NULL OR G.[VersionId] = @VersionId)
	  AND (@ReviewStageId IS NULL OR G.[ReviewStageId] = @ReviewStageId)
	  AND (@ReviewGroupId IS NULL OR G.[ReviewGroupId] = @ReviewGroupId)
	  AND (@GroupName IS NULL OR G.[GroupName] = @GroupName)
)
