-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-08 17:38:57.797
-- Description  : Creates an auto checker build combination name
-- Example      : SELECT [qan].[FCreateAcBuildCombinationName]('S15C', 'FAB 2', NULL, 'PRB 10');
-- ================================================================================================
CREATE FUNCTION [qan].[FCreateAcBuildCombinationName]
(
	  @DesignName              VARCHAR(10)
	, @FabricationFacilityName VARCHAR(50)
	, @TestFlowName            VARCHAR(50)
	, @ProbeConversionName     VARCHAR(50)
)
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @Result VARCHAR(200) = '';
	IF (@DesignName IS NOT NULL)              SET @Result = @DesignName;
	IF (@FabricationFacilityName IS NOT NULL) SET @Result = @Result + '-' + @FabricationFacilityName;
	IF (@TestFlowName IS NOT NULL)            SET @Result = @Result + '-' + @TestFlowName;
	IF (@ProbeConversionName IS NOT NULL)     SET @Result = @Result + '-' + @ProbeConversionName;
	RETURN @Result;
END
