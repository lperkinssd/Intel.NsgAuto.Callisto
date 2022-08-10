-- ==========================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-14 15:23:17.677
-- Description  : Gets mm recipe reviewers
-- Example      : SELECT * FROM [qan].[FMMRecipeReviewers](NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- ==========================================================================================================
CREATE FUNCTION [qan].[FMMRecipeReviewers]
(
	  @Id BIGINT = NULL
	, @VersionId BIGINT = NULL
	, @ReviewStageId INT = NULL
	, @ReviewGroupId INT = NULL
	, @ReviewerId INT = NULL
	, @Idsid VARCHAR(50) = NULL
	, @Wwid VARCHAR(10) = NULL
	, @Email VARCHAR(255) = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  R.[Id]
		, R.[VersionId]
		, R.[ReviewStageId]
		, R.[ReviewGroupId]
		, R.[ReviewerId]
		, R.[Name]
		, R.[Idsid]
		, R.[Wwid]
		, R.[Email]
	FROM [qan].[MMRecipeReviewers] AS R WITH (NOLOCK)
	WHERE (@Id IS NULL OR R.[Id] = @Id)
	  AND (@VersionId IS NULL OR R.[VersionId] = @VersionId)
	  AND (@ReviewStageId IS NULL OR R.[ReviewStageId] = @ReviewStageId)
	  AND (@ReviewGroupId IS NULL OR R.[ReviewGroupId] = @ReviewGroupId)
	  AND (@ReviewerId IS NULL OR R.[ReviewerId] = @ReviewerId)
	  AND (@Idsid IS NULL OR R.[Idsid] = @Idsid)
	  AND (@Wwid IS NULL OR R.[Wwid] = @Wwid)
	  AND (@Email IS NULL OR R.[Email] = @Email)
)
