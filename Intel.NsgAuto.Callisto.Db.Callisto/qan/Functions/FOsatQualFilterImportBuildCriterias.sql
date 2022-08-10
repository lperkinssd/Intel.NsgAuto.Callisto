-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-28 20:45:02.657
-- Description  : Gets osat import build criterias
-- Example      : SELECT * FROM [qan].[FOsatQualFilterImportBuildCriterias](NULL, 1, NULL, NULL);
-- ================================================================================================
CREATE FUNCTION [qan].[FOsatQualFilterImportBuildCriterias]
(
	  @Id                  BIGINT = NULL
	, @ImportId            INT    = NULL
	, @BuildCriteriaSetId  BIGINT = NULL
	, @BuildCriteriaId     BIGINT = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  [Id]                                                      = IC.[Id]
		, [ImportId]                                                = IC.[ImportId]
		, [GroupIndex]                                              = IC.[GroupIndex]
		, [GroupSourceIndex]                                        = IC.[GroupSourceIndex]
		, [CriteriaIndex]                                           = IC.[CriteriaIndex]
		, [CriteriaSourceIndex]                                     = IC.[CriteriaSourceIndex]
		, [BuildCriteriaId]                                         = IC.[BuildCriteriaId]
		, [BuildCriteriaBuildCriteriaSetId]                         = BC.[BuildCriteriaSetId]
		, [BuildCriteriaOrdinal]                                    = BC.[Ordinal]
		, [BuildCriteriaName]                                       = BC.[Name]
		, [BuildCriteriaCreatedBy]                                  = BC.[CreatedBy]
		, [BuildCriteriaCreatedOn]                                  = BC.[CreatedOn]
		, [BuildCriteriaUpdatedBy]                                  = BC.[UpdatedBy]
		, [BuildCriteriaUpdatedOn]                                  = BC.[UpdatedOn]
		, [BuildCriteriaSetId]                                      = IC.[BuildCriteriaSetId]
		, [BuildCriteriaSetVersion]                                 = BS.[Version]
		, [BuildCriteriaSetIsPOR]                                   = BS.[IsPOR]
		, [BuildCriteriaSetIsActive]                                = BS.[IsActive]
		, [BuildCriteriaSetStatusId]                                = BS.[StatusId]
		, [BuildCriteriaSetStatusName]                              = BS.[StatusName]
		, [BuildCriteriaSetCreatedBy]                               = BS.[CreatedBy]
		, [BuildCriteriaSetCreatedByUserName]                       = BS.[CreatedByUserName]
		, [BuildCriteriaSetCreatedOn]                               = BS.[CreatedOn]
		, [BuildCriteriaSetUpdatedBy]                               = BS.[UpdatedBy]
		, [BuildCriteriaSetUpdatedByUserName]                       = BS.[UpdatedByUserName]
		, [BuildCriteriaSetUpdatedOn]                               = BS.[UpdatedOn]
		, [BuildCriteriaSetEffectiveOn]                             = BS.[EffectiveOn]
		, [BuildCriteriaSetBuildCombinationId]                      = BS.[BuildCombinationId]
		, [BuildCriteriaSetBuildCombinationIsActive]                = BS.[BuildCombinationIsActive]
		, [BuildCriteriaSetBuildCombinationDesignId]                = BS.[BuildCombinationDesignId]
		, [BuildCriteriaSetBuildCombinationDesignName]              = BS.[BuildCombinationDesignName]
		, [BuildCriteriaSetBuildCombinationDesignFamilyId]          = BS.[BuildCombinationDesignFamilyId]
		, [BuildCriteriaSetBuildCombinationDesignFamilyName]        = BS.[BuildCombinationDesignFamilyName]
		, [BuildCriteriaSetBuildCombinationDesignIsActive]          = BS.[BuildCombinationDesignIsActive]
		, [BuildCriteriaSetBuildCombinationDesignCreatedBy]         = BS.[BuildCombinationDesignCreatedBy]
		, [BuildCriteriaSetBuildCombinationDesignCreatedOn]         = BS.[BuildCombinationDesignCreatedOn]
		, [BuildCriteriaSetBuildCombinationDesignUpdatedBy]         = BS.[BuildCombinationDesignUpdatedBy]
		, [BuildCriteriaSetBuildCombinationDesignUpdatedOn]         = BS.[BuildCombinationDesignUpdatedOn]
		, [BuildCriteriaSetBuildCombinationPartUseTypeId]           = BS.[BuildCombinationPartUseTypeId]
		, [BuildCriteriaSetBuildCombinationPartUseTypeName]         = BS.[BuildCombinationPartUseTypeName]
		, [BuildCriteriaSetBuildCombinationPartUseTypeAbbreviation] = BS.[BuildCombinationPartUseTypeAbbreviation]
		, [BuildCriteriaSetBuildCombinationMaterialMasterField]     = BS.[BuildCombinationMaterialMasterField]
		, [BuildCriteriaSetBuildCombinationIntelLevel1PartNumber]   = BS.[BuildCombinationIntelLevel1PartNumber]
		, [BuildCriteriaSetBuildCombinationIntelProdName]           = BS.[BuildCombinationIntelProdName]
		, [BuildCriteriaSetBuildCombinationIntelMaterialPn]         = BS.[BuildCombinationIntelMaterialPn]
		, [BuildCriteriaSetBuildCombinationAssyUpi]                 = BS.[BuildCombinationAssyUpi]
		, [BuildCriteriaSetBuildCombinationDeviceName]              = BS.[BuildCombinationDeviceName]
		, [BuildCriteriaSetBuildCombinationMpp]                     = BS.[BuildCombinationMpp]
		, [BuildCriteriaSetBuildCombinationCreatedBy]               = BS.[BuildCombinationCreatedBy]
		, [BuildCriteriaSetBuildCombinationCreatedOn]               = BS.[BuildCombinationCreatedOn]
		, [BuildCriteriaSetBuildCombinationUpdatedBy]               = BS.[BuildCombinationUpdatedBy]
		, [BuildCriteriaSetBuildCombinationUpdatedOn]               = BS.[BuildCombinationUpdatedOn]
		, [BuildCriteriaSetBuildCombinationIsPublishable]           = BS.[BuildCombinationIsPublishable]
		, [BuildCriteriaSetBuildCombinationPublishDisabledBy]       = BS.[BuildCombinationPublishDisabledBy]
		, [BuildCriteriaSetBuildCombinationPublishDisabledOn]       = BS.[BuildCombinationPublishDisabledOn]
		, [BuildCriteriaSetBuildCombinationPorBuildCriteriaSetId]   = BS.[BuildCombinationPorBuildCriteriaSetId]
		, [BuildCriteriaSetBuildCombinationOsatId]                  = BS.[BuildCombinationOsatId]
		, [BuildCriteriaSetBuildCombinationOsatName]                = BS.[BuildCombinationOsatName]
	FROM [qan].[OsatQualFilterImportBuildCriterias]                                     AS IC  WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[FOsatBuildCriterias](NULL, NULL, NULL)                       AS BC                ON (BC.[Id] = IC.[BuildCriteriaId])
	LEFT OUTER JOIN [qan].[FOsatBuildCriteriaSets](NULL, NULL, NULL, NULL, NULL, NULL, NULL)  AS BS                ON (BS.[Id] = IC.[BuildCriteriaSetId])
	WHERE (@Id                 IS NULL OR IC.[Id]                 = @Id)
	  AND (@ImportId           IS NULL OR IC.[ImportId]           = @ImportId)
	  AND (@BuildCriteriaSetId IS NULL OR IC.[BuildCriteriaSetId] = @BuildCriteriaSetId)
	  AND (@BuildCriteriaId    IS NULL OR IC.[BuildCriteriaId]    = @BuildCriteriaId)
)
