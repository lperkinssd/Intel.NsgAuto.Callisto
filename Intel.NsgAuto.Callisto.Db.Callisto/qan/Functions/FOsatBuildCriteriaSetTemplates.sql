-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16
-- Description  : Gets osat build criteria set templates
-- Example      : SELECT * FROM [qan].[FOsatBuildCriteriaSetTemplates](NULL, NULL, NULL);
-- ======================================================================================
CREATE FUNCTION [qan].[FOsatBuildCriteriaSetTemplates]
(
	  @Id INT = NULL
	, @Name VARCHAR(50) = NULL
	, @DesignFamilyId INT = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  B.[Id]
		, B.[Name]
		, B.[DesignFamilyId]
		, DF.[Name] AS [DesignFamilyName]
	FROM [qan].[OsatBuildCriteriaSetTemplates] AS B WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Id] = B.[DesignFamilyId])
	WHERE (@Id IS NULL OR B.[Id] = @Id)
	  AND (@Name IS NULL OR B.[Name] = @Name)
	  AND (@DesignFamilyId IS NULL OR B.[DesignFamilyId] = @DesignFamilyId)
)
