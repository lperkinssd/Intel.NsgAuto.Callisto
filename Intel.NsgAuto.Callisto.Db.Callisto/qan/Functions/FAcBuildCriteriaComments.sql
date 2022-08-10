-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-02-01 13:20:26.793
-- Description  : Gets auto checker build criteria comments
-- Example      : SELECT * FROM [qan].[FAcBuildCriteriaComments](NULL, 1);
-- =======================================================================
CREATE FUNCTION [qan].[FAcBuildCriteriaComments]
(
	  @Id               BIGINT = NULL
	, @BuildCriteriaId  INT    = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  C.[Id]
		, C.[BuildCriteriaId]
		, C.[Text]
		, C.[CreatedBy]
		, UC.[Name] AS [CreatedByUserName]
		, C.[CreatedOn]
		, C.[UpdatedBy]
		, UU.[Name] AS [UpdatedByUserName]
		, C.[UpdatedOn]
	FROM [qan].[AcBuildCriteriaComments] AS C WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[Users] AS UC WITH (NOLOCK) ON (UC.[IdSid] = C.[CreatedBy])
	LEFT OUTER JOIN [qan].[Users] AS UU WITH (NOLOCK) ON (UU.[IdSid] = C.[UpdatedBy])
	WHERE (@Id IS NULL OR C.[Id] = @Id)
	  AND (@BuildCriteriaId IS NULL OR C.[BuildCriteriaId] = @BuildCriteriaId)
)
