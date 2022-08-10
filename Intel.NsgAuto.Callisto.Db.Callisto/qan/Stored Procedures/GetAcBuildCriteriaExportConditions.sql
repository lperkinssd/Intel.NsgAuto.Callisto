-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-20 11:57:58.703
-- Description  : Gets auto checker build criteria export conditions
-- Example      : EXEC [qan].[GetAcBuildCriteriaExportConditions] 'bricschx', 1;
-- =================================================================================
CREATE PROCEDURE [qan].[GetAcBuildCriteriaExportConditions]
(
	  @UserId                  VARCHAR(25)
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
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [qan].[FAcBuildCriteriaExportConditions](@UserId, @BuildCriteriaIsPOR, @Id, @BuildCriteriaId, @AttributeTypeId, @AttributeTypeName, @ComparisonOperationId, @ComparisonOperationKey, @Value, @BuildCombinationId, @DesignId, @FabricationFacilityId, @TestFlowIdIsNull, @TestFlowId, @ProbeConversionIdIsNull, @ProbeConversionId) ORDER BY [DesignName], [FabricationFacilityName], [TestFlowName], [ProbeConversionName], [AttributeTypeName], [Id];

END
