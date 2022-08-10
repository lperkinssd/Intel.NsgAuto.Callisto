-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-06-24 14:14:02.567
-- Description  : Gets osat qual filter imports
-- Example      : SELECT * FROM [qan].[FOsatQualFilterImports](NULL, NULL);
-- ============================================================================
CREATE FUNCTION [qan].[FOsatQualFilterImports]
(
	  @UserId     VARCHAR(25) = NULL
	, @Id         INT         = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  [Id]                        = I.[Id]
		, [CreatedBy]                 = I.[CreatedBy]
		, [CreatedByUserName]         = UC.[Name]
		, [CreatedOn]                 = I.[CreatedOn]
		, [UpdatedBy]                 = I.[UpdatedBy]
		, [UpdatedByUserName]         = UU.[Name]
		, [UpdatedOn]                 = I.[UpdatedOn]
		, [FileName]                  = I.[FileName]
		, [FileLengthInBytes]         = I.[FileLengthInBytes]
		, [MessageErrorsExist]        = I.[MessageErrorsExist]
		, [AllowBuildCriteriaActions] = I.[AllowBuildCriteriaActions]
		, [DesignId]                  = I.[DesignId]
		, [DesignName]                = D.[Name]
		, [DesignFamilyId]            = D.[DesignFamilyId]
		, [DesignFamilyName]          = D.[DesignFamilyName]
		, [DesignIsActive]            = D.[IsActive]
		, [DesignMixTypeId]           = D.[MixTypeId]
		, [DesignMixTypeName]         = D.[MixTypeName]
		, [DesignMixTypeAbbreviation] = D.[MixTypeAbbreviation]
		, [DesignCreatedBy]           = D.[CreatedBy]
		, [DesignCreatedOn]           = D.[CreatedOn]
		, [DesignUpdatedBy]           = D.[UpdatedBy]
		, [DesignUpdatedOn]           = D.[UpdatedOn]
	FROM [qan].[OsatQualFilterImports] AS I WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[FProducts](NULL, NULL, NULL, NULL, NULL, NULL) AS D                ON (D.[Id] = I.[DesignId])
	LEFT OUTER JOIN [qan].[Users]                                         AS UC WITH (NOLOCK) ON (UC.[IdSid] = I.[CreatedBy])
	LEFT OUTER JOIN [qan].[Users]                                         AS UU WITH (NOLOCK) ON (UU.[IdSid] = I.[UpdatedBy])
	WHERE (@Id     IS NULL OR I.[Id] = @Id)
	  AND (@UserId IS NULL OR D.[DesignFamilyName] IN (
		SELECT PCR.Process
			  FROM [qan].[PreferredRole] PR 
				   INNER JOIN [qan].[ProcessRoles] PCR On PR.ActiveRole = PCR.RoleName
			  where UserId = @UserId
	  ))
)
