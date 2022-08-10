-- ==========================================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-28 16:47:45.240
-- Description  : Gets osat pas versions
-- Example      : SELECT * FROM [qan].[FOsatPasVersions](1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- ==========================================================================================================
CREATE FUNCTION [qan].[FOsatPasVersions]
(
	  @Id              INT         = NULL
	, @UserId          VARCHAR(25) = NULL -- if not null will restrict results to user's allowed design families
	, @Version         INT         = NULL
	, @IsActive        BIT         = NULL
	, @IsPOR           BIT         = NULL
	, @StatusId        INT         = NULL
	, @CombinationId   INT         = NULL
	, @OsatId          INT         = NULL
	, @DesignFamilyId  INT         = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  V.[Id]
		, V.[Version]
		, V.[IsActive]
		, V.[IsPOR]
		, V.[StatusId] AS [StatusId]
		, S.[Name] AS [StatusName]
		, V.[CombinationId]
		, C.[OsatId] AS [CombinationOsatId]
		, C.[OsatName] AS [CombinationOsatName]
		, C.[OsatCreatedBy] AS [CombinationOsatCreatedBy]
		, C.[OsatCreatedOn] AS [CombinationOsatCreatedOn]
		, C.[OsatUpdatedBy] AS [CombinationOsatUpdatedBy]
		, C.[OsatUpdatedOn] AS [CombinationOsatUpdatedOn]
		, C.[DesignFamilyId] AS [CombinationDesignFamilyId]
		, C.[DesignFamilyName] AS [CombinationDesignFamilyName]
		, C.[CreatedBy] AS [CombinationCreatedBy]
		, C.[CreatedOn] AS [CombinationCreatedOn]
		, C.[UpdatedBy] AS [CombinationUpdatedBy]
		, C.[UpdatedOn] AS [CombinationUpdatedOn]
		, V.[CreatedBy]
		, UC.[Name] AS [CreatedByUserName]
		, V.[CreatedOn]
		, V.[UpdatedBy]
		, UU.[Name] AS [UpdatedByUserName]
		, V.[UpdatedOn]
		, V.[OriginalFileName]
		, V.[FileLengthInBytes]
	FROM [qan].[OsatPasVersions]                                   AS V  WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[Statuses]                               AS S  WITH (NOLOCK) ON (V.[StatusId] = S.[Id])
	LEFT OUTER JOIN [qan].[Users]                                  AS UC WITH (NOLOCK) ON (UC.[IdSid] = V.[CreatedBy])
	LEFT OUTER JOIN [qan].[Users]                                  AS UU WITH (NOLOCK) ON (UU.[IdSid] = V.[UpdatedBy])
	LEFT OUTER JOIN [qan].[FOsatPasCombinations](NULL, NULL, NULL) AS C                ON (C.[Id] = V.[CombinationId])
	WHERE (@Id IS NULL OR V.[Id] = @Id)
	  AND (@UserId         IS NULL OR C.[DesignFamilyName] IN (SELECT [Process] FROM [qan].[UserProcessRoles] WITH (NOLOCK) WHERE [IdSid] = @UserId))
	  AND (@Version        IS NULL OR V.[Version] = @Version)
	  AND (@IsActive       IS NULL OR V.[IsActive] = @IsActive)
	  AND (@IsPOR          IS NULL OR V.[IsPOR] = @IsPOR)
	  AND (@StatusId       IS NULL OR V.[StatusId] = @StatusId)
	  AND (@CombinationId  IS NULL OR V.[CombinationId] = @CombinationId)
	  AND (@OsatId         IS NULL OR C.[OsatId] = @OsatId)
	  AND (@DesignFamilyId IS NULL OR C.[DesignFamilyId] = @DesignFamilyId)
)
