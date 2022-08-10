-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-30 13:19:59.960
-- Description  : Returns the mpp from an osat qual filter device attribute value
-- Examples     : SELECT [qan].[FOsatQfDeviceAvToMpp]('S26A-21ST-D422-22'); -- -22
--                SELECT [qan].[FOsatQfDeviceAvToMpp]('S26A-21ST-D422');    -- NULL
-- =================================================================================
CREATE FUNCTION [qan].[FOsatQfDeviceAvToMpp]
(
	  @Device VARCHAR(4000)
)
RETURNS VARCHAR(25)
AS
BEGIN
	DECLARE @Result VARCHAR(25);
	SET @Device = NULLIF(LTRIM(RTRIM(@Device)), '');
	IF (LEN(@Device) > 14)
	BEGIN
		SET @Result = RIGHT(@Device, LEN(@Device) - 14);
	END;
	RETURN (@Result);
END