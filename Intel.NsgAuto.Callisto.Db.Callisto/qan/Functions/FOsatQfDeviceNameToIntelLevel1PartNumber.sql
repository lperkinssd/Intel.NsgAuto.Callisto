-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-30 14:02:22.517
-- Description  : Returns the intel level 1 part number from the qual filter device name
-- Examples     : SELECT [qan].[FOsatQfDeviceNameToIntelLevel1PartNumber]('PF29P32B11LDSGA');
--                SELECT [qan].[FOsatQfDeviceNameToIntelLevel1PartNumber]('PF29P32B11LDSGA-ES');
-- ================================================================================================
CREATE FUNCTION [qan].[FOsatQfDeviceNameToIntelLevel1PartNumber]
(
	  @DeviceName VARCHAR(4000)
)
RETURNS VARCHAR(25)
AS
BEGIN
	DECLARE @Result VARCHAR(25) = NULLIF(LEFT(UPPER(LTRIM(RTRIM(@DeviceName))), 15), '');
	RETURN (@Result);
END