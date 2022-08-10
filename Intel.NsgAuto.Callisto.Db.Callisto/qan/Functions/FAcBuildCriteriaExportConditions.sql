-- ======================================================================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-20 09:52:54.997
-- Description  : Gets auto checker build criteria export conditions
-- Example      : SELECT * FROM [qan].[FAcBuildCriteriaExportConditions](NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- ======================================================================================================================================================================
CREATE FUNCTION [qan].[FAcBuildCriteriaExportConditions]
(
	  @UserId                  VARCHAR(25)  = NULL -- if not null will restrict results to user's allowed design families
	, @BuildCriteriaIsPOR      BIT          = NULL
	, @Id                      BIGINT       = NULL
	, @BuildCriteriaId         BIGINT       = NULL
	, @AttributeTypeId         INT          = NULL
	, @AttributeTypeName       VARCHAR(50)  = NULL
	, @ComparisonOperationId   INT          = NULL
	, @ComparisonOperationKey  VARCHAR(25)  = NULL
	, @Value                   VARCHAR(MAX) = NULL
	, @BuildCombinationId      INT          = NULL
	, @DesignId                INT          = NULL
	, @FabricationFacilityId   INT          = NULL
	, @TestFlowIdIsNull        BIT          = NULL
	, @TestFlowId              INT          = NULL
	, @ProbeConversionIdIsNull BIT          = NULL
	, @ProbeConversionId       INT          = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  C.[Id]
		, C.[BuildCriteriaId]
		, BC.[DesignId]
		, BC.[DesignName]
		, BC.[DesignFamilyId]
		, BC.[DesignFamilyName]
		, BC.[DesignIsActive]
		, BC.[DesignCreatedBy]
		, BC.[DesignCreatedOn]
		, BC.[DesignUpdatedBy]
		, BC.[DesignUpdatedOn]
		, BC.[FabricationFacilityId]
		, BC.[FabricationFacilityName]
		, BC.[TestFlowId]
		, BC.[TestFlowName]
		, BC.[ProbeConversionId]
		, BC.[ProbeConversionName]
		, C.[AttributeTypeId]
		, C.[AttributeTypeName]
		, C.[AttributeTypeNameDisplay]
		, C.[AttributeTypeDataTypeId]
		, C.[AttributeTypeDataTypeName]
		, C.[AttributeTypeDataTypeNameDisplay]
		, C.[AttributeTypeCreatedBy]
		, C.[AttributeTypeCreatedOn]
		, C.[AttributeTypeUpdatedBy]
		, C.[AttributeTypeUpdatedOn]
		, C.[ComparisonOperationId]
		, C.[ComparisonOperationKey]
		, C.[ComparisonOperationKeyTreadstone]
		, C.[ComparisonOperationName]
		, C.[ComparisonOperationOperandTypeId]
		, C.[ComparisonOperationOperandTypeName]
		, C.[Value]
		, C.[CreatedBy]
		, C.[CreatedOn]
		, C.[UpdatedBy]
		, C.[UpdatedOn]
	FROM [qan].[FAcBuildCriteriaConditions](@Id, @UserId, @BuildCriteriaId, @AttributeTypeId, @AttributeTypeName, @ComparisonOperationId, @ComparisonOperationKey, @Value)                   AS C
	LEFT OUTER JOIN [qan].[AcBuildCriterias]                                                                                                                                                 AS B  WITH (NOLOCK) ON (B.[Id] = C.[BuildCriteriaId])
	LEFT OUTER JOIN [qan].[FAcBuildCombinations](@BuildCombinationId, NULL, @DesignId, @FabricationFacilityId, @TestFlowIdIsNull, @TestFlowId, @ProbeConversionIdIsNull, @ProbeConversionId) AS BC               ON (BC.[Id] = B.[BuildCombinationId])
	WHERE @BuildCriteriaIsPOR IS NULL OR B.[IsPOR] = @BuildCriteriaIsPOR
)
