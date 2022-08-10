-- ===========================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-14 15:27:15.960
-- Description  : Gets mm recipe review stages
-- Example      : SELECT * FROM [qan].[FMMRecipeReviewGroups](NULL, NULL, NULL, NULL, NULL);
-- ===========================================================================================
CREATE FUNCTION [qan].[FMMRecipeReviewGroups]
(
	  @Id BIGINT = NULL
	, @VersionId BIGINT = NULL
	, @ReviewStageId INT = NULL
	, @ReviewGroupId INT = NULL
	, @GroupName VARCHAR(50) = NULL
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
	FROM [qan].[MMRecipeReviewGroups] AS G WITH (NOLOCK)
	WHERE (@Id IS NULL OR G.[Id] = @Id)
	  AND (@VersionId IS NULL OR G.[VersionId] = @VersionId)
	  AND (@ReviewStageId IS NULL OR G.[ReviewStageId] = @ReviewStageId)
	  AND (@ReviewGroupId IS NULL OR G.[ReviewGroupId] = @ReviewGroupId)
	  AND (@GroupName IS NULL OR G.[GroupName] = @GroupName)
)
