-- ==========================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-07 10:02:20.013
-- Description  : Gets auto checker build criteria review stages
-- Example      : SELECT * FROM [qan].[FAcBuildCriteriaReviewStages](NULL, NULL, NULL, NULL, NULL, NULL);
-- ==========================================================================================================
CREATE FUNCTION [qan].[FAcBuildCriteriaReviewStages]
(
	  @Id BIGINT = NULL
	, @VersionId BIGINT = NULL
	, @ReviewStageId INT = NULL
	, @StageName VARCHAR(50) = NULL
	, @ParentStageId INT = NULL
	, @IsNextInParallel BIT = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  S.[Id]
		, S.[VersionId]
		, S.[ReviewStageId]
		, S.[StageName]
		, S.[DisplayName]
		, S.[Sequence]
		, S.[ParentStageId]
		, S.[IsNextInParallel]
	FROM [qan].[AcBuildCriteriaReviewStages] AS S WITH (NOLOCK)
	WHERE (@Id IS NULL OR S.[Id] = @Id)
	  AND (@VersionId IS NULL OR S.[VersionId] = @VersionId)
	  AND (@ReviewStageId IS NULL OR S.[ReviewStageId] = @ReviewStageId)
	  AND (@StageName IS NULL OR S.[StageName] = @StageName)
	  AND (@ParentStageId IS NULL OR S.[ParentStageId] = @ParentStageId)
	  AND (@IsNextInParallel IS NULL OR S.[IsNextInParallel] = @IsNextInParallel)
)
