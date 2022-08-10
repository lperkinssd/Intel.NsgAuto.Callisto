-- ====================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-30 14:28:50.750
-- Description  : Determines the device name from various osat qual filter values
-- Examples     : SELECT [qan].[FOsatQfValuesToDeviceName](1, 'N38A-12FF-C521', NULL);
--                SELECT [qan].[FOsatQfValuesToDeviceName](2, 'S26A SDP 32GB BGA 256 PG1 4DK 12', 'S26A-11ME-D421');
-- ====================================================================================================================
CREATE FUNCTION [qan].[FOsatQfValuesToDeviceName]
(
	  @DesignFamilyId    INT
	, @PartNumberDecode  VARCHAR(4000)
	, @DeviceNameAv      VARCHAR(25)
)
RETURNS VARCHAR(25)
AS
BEGIN
	SET @PartNumberDecode = NULLIF(UPPER(LTRIM(RTRIM(@PartNumberDecode))), '');
	DECLARE @Result VARCHAR(25) =
		CASE @DesignFamilyId
			WHEN 1 /* NAND   */ THEN LEFT(@PartNumberDecode, 14)
			WHEN 2 /* Optane */ THEN @DeviceNameAv
			ELSE NULL
		END;

	RETURN (@Result);
END