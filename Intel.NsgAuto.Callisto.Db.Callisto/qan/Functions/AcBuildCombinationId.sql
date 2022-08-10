-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-20 14:06:57.123
-- Description  : Returns the auto checker build combination id matching the parameters, or null if none exists
-- Example      : SELECT [qan].[AcBuildCombinationId](1, 1, 1, NULL);
-- ===============================================================================================================
CREATE FUNCTION [qan].[AcBuildCombinationId](@DesignId INT, @FabricationFacilityId INT, @TestFlowId INT, @ProbeConversionId INT)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT;
	DECLARE @Count INT;
	SELECT @Count = COUNT(*), @Result = MIN([Id]) FROM [qan].[AcBuildCombinations]
		WHERE [DesignId] = @DesignId
		  AND [FabricationFacilityId] = @FabricationFacilityId
		  AND (([TestFlowId] = @TestFlowId) OR ([TestFlowId] IS NULL AND @TestFlowId IS NULL))
		  AND (([ProbeConversionId] = @ProbeConversionId) OR ([ProbeConversionId] IS NULL AND @ProbeConversionId IS NULL))
	IF (@Count <> 1) SET @Result = NULL;
	RETURN @Result;
END
