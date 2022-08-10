-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-01 15:57:00.240
-- Description  : Gets osat build criteria sets
-- Example      : SELECT * FROM [qan].[FOsatBuildCriteriaSets](1, NULL, NULL, NULL, NULL, NULL, NULL);
-- =====================================================================================================
CREATE FUNCTION [qan].[FOsatBuildCriteriaSets]
(
	  @Id                  BIGINT       = NULL
	, @UserId              VARCHAR(25)  = NULL -- if not null will restrict results to user's allowed design families
	, @Version             INT          = NULL
	, @IsPOR               BIT          = NULL
	, @IsActive            BIT          = NULL
	, @StatusId            INT          = NULL
	, @BuildCombinationId  INT          = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  B.[Id]
		, B.[Version]
		, B.[IsPOR]
		, B.[IsActive]
		, B.[StatusId]
		, S.[Name] AS [StatusName]
		, B.[CreatedBy]
		, UC.[Name] AS [CreatedByUserName]
		, B.[CreatedOn]
		, B.[UpdatedBy]
		, UU.[Name] AS [UpdatedByUserName]
		, B.[UpdatedOn]
		, B.[EffectiveOn]
		, B.[BuildCombinationId]
		, C.[IsActive] AS [BuildCombinationIsActive]
		, C.[DesignId] AS [BuildCombinationDesignId]
		, C.[DesignName] AS [BuildCombinationDesignName]
		, C.[DesignFamilyId] AS [BuildCombinationDesignFamilyId]
		, C.[DesignFamilyName] AS [BuildCombinationDesignFamilyName]
		, C.[DesignIsActive] AS [BuildCombinationDesignIsActive]
		, C.[DesignCreatedBy] AS [BuildCombinationDesignCreatedBy]
		, C.[DesignCreatedOn] AS [BuildCombinationDesignCreatedOn]
		, C.[DesignUpdatedBy] AS [BuildCombinationDesignUpdatedBy]
		, C.[DesignUpdatedOn] AS [BuildCombinationDesignUpdatedOn]
		, C.[PartUseTypeId] AS [BuildCombinationPartUseTypeId]
		, C.[PartUseTypeName] AS [BuildCombinationPartUseTypeName]
		, C.[PartUseTypeAbbreviation] AS [BuildCombinationPartUseTypeAbbreviation]
		, C.[MaterialMasterField] AS [BuildCombinationMaterialMasterField]
		, C.[IntelLevel1PartNumber] AS [BuildCombinationIntelLevel1PartNumber]
		, C.[IntelProdName] AS [BuildCombinationIntelProdName]
		, C.[IntelMaterialPn] AS [BuildCombinationIntelMaterialPn]
		, C.[AssyUpi] AS [BuildCombinationAssyUpi]
		, C.[DeviceName] AS [BuildCombinationDeviceName]
		, C.[Mpp] AS [BuildCombinationMpp]
		, C.[CreatedBy] AS [BuildCombinationCreatedBy]
		, C.[CreatedOn] AS [BuildCombinationCreatedOn]
		, C.[UpdatedBy] AS [BuildCombinationUpdatedBy]
		, C.[UpdatedOn] AS [BuildCombinationUpdatedOn]
		, CAST(CASE WHEN C.[PublishDisabledOn] IS NOT NULL THEN 0 ELSE 1 END AS BIT) AS [BuildCombinationIsPublishable]
		, C.[PublishDisabledBy] AS [BuildCombinationPublishDisabledBy]
		, C.[PublishDisabledOn] AS [BuildCombinationPublishDisabledOn]
		, C.[PorBuildCriteriaSetId] AS [BuildCombinationPorBuildCriteriaSetId]
		, C.Osatid AS [BuildCombinationOsatId]
		, C.OsatName AS [BuildCombinationOsatName]
	FROM [qan].[OsatBuildCriteriaSets]                                                                         AS B  WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[Statuses]                                                                           AS S  WITH (NOLOCK) ON (S.[Id] = B.[StatusId])
	LEFT OUTER JOIN [qan].[FOsatBuildCombinations](NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) AS C                ON (C.[Id] = B.[BuildCombinationId])
	LEFT OUTER JOIN [qan].[Users]                                                                              AS UC WITH (NOLOCK) ON (UC.[IdSid] = B.[CreatedBy])
	LEFT OUTER JOIN [qan].[Users]                                                                              AS UU WITH (NOLOCK) ON (UU.[IdSid] = B.[UpdatedBy])
	WHERE (@Id                 IS NULL OR B.[Id] = @Id)
	  AND (@UserId             IS NULL OR C.[DesignFamilyName] IN (SELECT [Process] FROM [qan].[UserProcessRoles] WITH (NOLOCK) WHERE [IdSid] = @UserId))
	  AND (@Version            IS NULL OR B.[Version] = @Version)
	  AND (@IsPOR              IS NULL OR B.[IsPOR] = @IsPOR)
	  AND (@IsActive           IS NULL OR B.[IsActive] = @IsActive)
	  AND (@StatusId           IS NULL OR B.[StatusId] = @StatusId)
	  AND (@BuildCombinationId IS NULL OR B.[BuildCombinationId] = @BuildCombinationId)
)
