-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-30 13:04:50.170
-- Description  : Gets osat build criteria templates
-- Example      : SELECT * FROM [qan].[FOsatBuildCriteriaTemplates](NULL, NULL, NULL);
-- ======================================================================================
CREATE FUNCTION [qan].[FOsatBuildCriteriaTemplates]
(
	  @Id            INT         = NULL
	, @SetTemplateId INT         = NULL
	, @Name          VARCHAR(50) = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  [Id]
		, [SetTemplateId]
		, [Ordinal]
		, [Name]
	FROM [qan].[OsatBuildCriteriaTemplates] WITH (NOLOCK)
	WHERE (@Id IS NULL OR [Id] = @Id)
	  AND (@SetTemplateId IS NULL OR [SetTemplateId] = @SetTemplateId)
	  AND (@Name IS NULL OR [Name] = @Name)
)
