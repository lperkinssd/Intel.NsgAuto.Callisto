-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16
-- Description  : Gets osat build criteria set reviewer decisions
-- Example      : SELECT * FROM [qan].[FOsatBuildCriteriaSetReviewDecisions](NULL, NULL, NULL, NULL, NULL, NULL);
-- ===============================================================================================================
CREATE FUNCTION [qan].[FOsatBuildCriteriaSetReviewDecisions]
(
	  @Id             BIGINT = NULL
	, @VersionId      BIGINT = NULL
	, @ReviewStageId  INT    = NULL
	, @ReviewGroupId  INT    = NULL
	, @ReviewerId     INT    = NULL
	, @IsApproved     BIT    = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  D.[Id]
		, D.[SnapshotReviewerId]
		, D.[VersionId]
		, D.[ReviewStageId]
		, D.[ReviewGroupId]
		, D.[ReviewerId]
		, D.[IsApproved]
		, D.[Comment]
		, D.[ReviewedOn]
	FROM [qan].[OsatBuildCriteriaSetReviewDecisions] AS D WITH (NOLOCK)
	WHERE (@Id IS NULL OR D.[Id] = @Id)
	  AND (@VersionId IS NULL OR D.[VersionId] = @VersionId)
	  AND (@ReviewStageId IS NULL OR D.[ReviewStageId] = @ReviewStageId)
	  AND (@ReviewGroupId IS NULL OR D.[ReviewGroupId] = @ReviewGroupId)
	  AND (@ReviewerId IS NULL OR D.[ReviewerId] = @ReviewerId)
	  AND (@IsApproved IS NULL OR D.[IsApproved] = @IsApproved)
)
