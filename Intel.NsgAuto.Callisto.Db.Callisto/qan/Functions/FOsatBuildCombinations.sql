-- =========================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-22 17:16:34.240
-- Description  : Gets osat build combinations
-- Example      : SELECT * FROM [qan].[FOsatBuildCombinations](NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- =========================================================================================================================
CREATE FUNCTION [qan].[FOsatBuildCombinations]
(
	  @Id                     INT           = NULL
	, @UserId                 VARCHAR(25)   = NULL -- if not null will restrict results to user's allowed design families
	, @IsActive               BIT           = NULL
	, @DesignId               INT           = NULL
	, @MaterialMasterField    VARCHAR(10)   = NULL
	, @IntelLevel1PartNumber  VARCHAR(25)   = NULL
	, @IntelProdName          VARCHAR(100)  = NULL
	, @IntelMaterialPn        VARCHAR(25)   = NULL
	, @AssyUpi                VARCHAR(25)   = NULL
	, @DeviceName             VARCHAR(25)   = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  C.[Id]
		, C.[IsActive]
		, C.[DesignId]
		, D.[Name] AS [DesignName]
		, D.[DesignFamilyId]
		, DF.[Name] AS [DesignFamilyName]
		, D.[IsActive] AS [DesignIsActive]
		, D.[CreatedBy] AS [DesignCreatedBy]
		, D.[CreatedOn] AS [DesignCreatedOn]
		, D.[UpdatedBy] AS [DesignUpdatedBy]
		, D.[UpdatedOn] AS [DesignUpdatedOn]
		, C.[PartUseTypeId]
		, P.[Name] AS [PartUseTypeName]
		, P.[Abbreviation] AS [PartUseTypeAbbreviation]
		, C.[MaterialMasterField]
		, C.[IntelLevel1PartNumber]
		, C.[IntelProdName]
		, C.[IntelMaterialPn]
		, C.[AssyUpi]
		, C.[DeviceName]
		, C.[Mpp]
		, C.[CreatedBy]
		, C.[CreatedOn]
		, C.[UpdatedBy]
		, C.[UpdatedOn]
		, CAST(CASE WHEN C.[PublishDisabledOn] IS NOT NULL THEN 0 ELSE 1 END AS BIT) AS [IsPublishable]
		, C.[PublishDisabledBy]
		, C.[PublishDisabledOn]
		, B.[Id] AS [PorBuildCriteriaSetId]
		, C.Osatid
		, O.Name as OsatName
	FROM [qan].[OsatBuildCombinations]            AS C  WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[Osats]                 AS O WITH  (NOLOCK) ON (O.[Id] = C.[Osatid])
	LEFT OUTER JOIN [qan].[Products]              AS D  WITH (NOLOCK) ON (D.[Id] = C.[DesignId])
	LEFT OUTER JOIN [ref].[DesignFamilies]        AS DF WITH (NOLOCK) ON (DF.[Id] = D.[DesignFamilyId])
	LEFT OUTER JOIN [ref].[PartUseTypes]          AS P  WITH (NOLOCK) ON (P.[Id] = C.[PartUseTypeId])
	LEFT OUTER JOIN [qan].[OsatBuildCriteriaSets] AS B  WITH (NOLOCK) ON (B.[BuildCombinationId] = C.[Id] AND B.[IsPOR] = 1)
	WHERE (@Id IS NULL OR C.[Id] = @Id)
	  AND (@UserId                IS NULL OR DF.[Name] IN (SELECT [Process] FROM [qan].[UserProcessRoles] WITH (NOLOCK) WHERE [IdSid] = @UserId))
	  AND (@IsActive              IS NULL OR C.[IsActive] = @IsActive)
	  AND (@DesignId              IS NULL OR C.[DesignId] = @DesignId)
	  AND (@MaterialMasterField   IS NULL OR C.[MaterialMasterField] = @MaterialMasterField)
	  AND (@IntelLevel1PartNumber IS NULL OR C.[IntelLevel1PartNumber] = @IntelLevel1PartNumber)
	  AND (@IntelProdName         IS NULL OR C.[IntelProdName] = @IntelProdName)
	  AND (@IntelMaterialPn       IS NULL OR C.[IntelMaterialPn] = @IntelMaterialPn)
	  AND (@AssyUpi               IS NULL OR C.[AssyUpi] = @AssyUpi)
	  AND (@DeviceName            IS NULL OR C.[DeviceName] = @DeviceName)
)
