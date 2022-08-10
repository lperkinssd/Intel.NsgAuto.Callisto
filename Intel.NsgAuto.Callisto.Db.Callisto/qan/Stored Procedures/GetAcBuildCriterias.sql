-- ===================================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 10:48:13.717
-- Description  : Gets auto checker build criterias
-- Example      : EXEC [qan].[GetAcBuildCriterias] 'bricschx', 1;
-- ===================================================================
CREATE PROCEDURE [qan].[GetAcBuildCriterias]
(
	  @UserId                   VARCHAR(25)
	, @Id                       BIGINT      = NULL
	, @Version                  INT         = NULL
	, @IsPOR                    BIT         = NULL
	, @IsActive                 BIT         = NULL
	, @StatusId                 INT         = NULL
	, @BuildCombinationId       INT         = NULL
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

	SELECT * FROM [qan].[FAcBuildCriterias](@Id, @UserId, @Version, @IsPOR, @IsActive, @StatusId, @BuildCombinationId, @DesignId, @FabricationFacilityId, @TestFlowIdIsNull, @TestFlowId, @ProbeConversionIdIsNull, @ProbeConversionId) ORDER BY [UpdatedOn] DESC, [Id] DESC;

END
