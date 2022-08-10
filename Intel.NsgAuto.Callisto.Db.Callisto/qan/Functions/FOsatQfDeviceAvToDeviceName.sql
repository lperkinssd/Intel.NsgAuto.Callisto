-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-30 13:13:24.813
-- Description  : Returns the device name from an osat qual filter device attribute value
-- Example      : SELECT [qan].[FOsatQfDeviceAvToDeviceName]('S26A-21ST-D422-22');
-- ======================================================================================
CREATE FUNCTION [qan].[FOsatQfDeviceAvToDeviceName]
(
	  @Device VARCHAR(4000)
)
RETURNS VARCHAR(25)
AS
BEGIN
	DECLARE @Result VARCHAR(25) = NULLIF(LEFT(LTRIM(RTRIM(@Device)), 14), '');
	RETURN (@Result);
END