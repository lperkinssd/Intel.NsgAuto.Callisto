-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16
-- Description  : Gets osat build criteria set comments
-- Example      : SELECT * FROM [qan].[FOsatBuildCriteriaSetComments](NULL, 1);
-- ============================================================================
CREATE FUNCTION [qan].[FOsatBuildCriteriaSetComments]
(
	  @Id                  BIGINT = NULL
	, @BuildCriteriaSetId  BIGINT = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  C.[Id]
		, C.[BuildCriteriaSetId]
		, C.[Text]
		, C.[CreatedBy]
		, UC.[Name] AS [CreatedByUserName]
		, C.[CreatedOn]
		, C.[UpdatedBy]
		, UU.[Name] AS [UpdatedByUserName]
		, C.[UpdatedOn]
	FROM [qan].[OsatBuildCriteriaSetComments] AS C WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[Users] AS UC WITH (NOLOCK) ON (UC.[IdSid] = C.[CreatedBy])
	LEFT OUTER JOIN [qan].[Users] AS UU WITH (NOLOCK) ON (UU.[IdSid] = C.[UpdatedBy])
	WHERE (@Id IS NULL OR C.[Id] = @Id)
	  AND (@BuildCriteriaSetId IS NULL OR C.[BuildCriteriaSetId] = @BuildCriteriaSetId)
)
