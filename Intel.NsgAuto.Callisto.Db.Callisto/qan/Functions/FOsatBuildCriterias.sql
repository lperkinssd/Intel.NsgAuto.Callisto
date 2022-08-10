-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-03-23 14:07:07.680
-- Description  : Gets osat build criterias
-- Example      : SELECT * FROM [qan].[FOsatBuildCriterias](1, NULL, NULL);
-- ============================================================================
CREATE FUNCTION [qan].[FOsatBuildCriterias]
(
	  @Id                  BIGINT = NULL
	, @BuildCriteriaSetId  BIGINT = NULL
	, @Ordinal             INT    = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  [Id]
		, [BuildCriteriaSetId]
		, [Ordinal]
		, [Name]
		, [CreatedBy]
		, [CreatedOn]
		, [UpdatedBy]
		, [UpdatedOn]
	FROM [qan].[OsatBuildCriterias] WITH (NOLOCK)
	WHERE (@Id IS NULL OR [Id] = @Id)
	  AND (@BuildCriteriaSetId IS NULL OR [BuildCriteriaSetId] = @BuildCriteriaSetId)
	  AND (@Ordinal IS NULL OR [Ordinal] = @Ordinal)
)
