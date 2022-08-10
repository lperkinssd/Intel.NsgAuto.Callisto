-- ==========================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-16 16:53:01.250
-- Description  : Gets auto checker build criteria templates
-- Example      : SELECT * FROM [qan].[FAcBuildCriteriaTemplates](NULL, NULL, NULL);
-- ==========================================================================================================================
CREATE FUNCTION [qan].[FAcBuildCriteriaTemplates]
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
	FROM [qan].[AcBuildCriteriaTemplates] AS B WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Id] = B.[DesignFamilyId])
	WHERE (@Id IS NULL OR B.[Id] = @Id)
	  AND (@Name IS NULL OR B.[Name] = @Name)
	  AND (@DesignFamilyId IS NULL OR B.[DesignFamilyId] = @DesignFamilyId)
)
