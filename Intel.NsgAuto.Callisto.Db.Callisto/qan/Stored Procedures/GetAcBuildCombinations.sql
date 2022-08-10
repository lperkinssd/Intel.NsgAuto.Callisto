-- ===================================================================
-- Author       : bricschx
-- Create date  : 2020-11-19 16:36:11.397
-- Description  : Gets auto checker build combinations
-- Example      : EXEC [qan].[GetAcBuildCombinations] 'bricschx';
-- ===================================================================
CREATE PROCEDURE [qan].[GetAcBuildCombinations]
(
	  @UserId                   VARCHAR(25)
	, @Id                       INT         = NULL
	, @DesignId                 INT         = NULL
	, @FabricationFacilityId    INT         = NULL
	, @TestFlowIdIsNull         BIT         = NULL
	, @TestFlowId               INT         = NULL
	, @ProbeConversionIdIsNull  INT         = NULL
	, @ProbeConversionId        INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [qan].[FAcBuildCombinations](@Id, @UserId, @DesignId, @FabricationFacilityId, @TestFlowIdIsNull, @TestFlowId, @ProbeConversionIdIsNull, @ProbeConversionId) ORDER BY [DesignName], [FabricationFacilityName], [TestFlowName], [ProbeConversionName], [Id];

END
