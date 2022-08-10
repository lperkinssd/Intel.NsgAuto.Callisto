-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-02-22 15:40:44.423
-- Description  : Gets osat pas combinations
-- Example      : SELECT * FROM [qan].[FOsatPasCombinations](NULL, NULL, NULL);
-- ============================================================================
CREATE FUNCTION [qan].[FOsatPasCombinations]
(
	  @Id INT = NULL
	, @OsatId INT = NULL
	, @DesignFamilyId INT = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  C.[Id]
		, C.[OsatId]
		, O.[Name] AS [OsatName]
		, O.[CreatedBy] AS [OsatCreatedBy]
		, O.[CreatedOn] AS [OsatCreatedOn]
		, O.[UpdatedBy] AS [OsatUpdatedBy]
		, O.[UpdatedOn] AS [OsatUpdatedOn]
		, C.[DesignFamilyId]
		, DF.[Name] AS [DesignFamilyName]
		, C.[CreatedBy]
		, C.[CreatedOn]
		, C.[UpdatedBy]
		, C.[UpdatedOn]
	FROM [qan].[OsatPasCombinations] AS C WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[Osats] AS O WITH (NOLOCK) ON (O.[Id] = C.[OsatId])
	LEFT OUTER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Id] = C.[DesignFamilyId])
	WHERE (@Id IS NULL OR C.[Id] = @Id)
	  AND (@OsatId IS NULL OR C.[OsatId] = @OsatId)
	  AND (@DesignFamilyId IS NULL OR C.[DesignFamilyId] = @DesignFamilyId)
)
