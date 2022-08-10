-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-30 14:45:11.063
-- Description  : Determines the intel prod name from various osat qual filter values
-- Examples     : SELECT [qan].[FOsatQfValuesToIntelProdName](1, 'N38A-12FF-C521');
--                SELECT [qan].[FOsatQfValuesToIntelProdName](2, 'S26A SDP 32GB BGA 256 PG1 4DK 12');
-- =====================================================================================================
CREATE FUNCTION [qan].[FOsatQfValuesToIntelProdName]
(
	  @DesignFamilyId    INT
	, @PartNumberDecode  VARCHAR(4000)
)
RETURNS VARCHAR(100)
AS
BEGIN
	SET @PartNumberDecode = NULLIF(UPPER(LTRIM(RTRIM(@PartNumberDecode))), '');
	DECLARE @Result VARCHAR(100) =
		CASE @DesignFamilyId
			WHEN 2 /* Optane */ THEN @PartNumberDecode
			ELSE NULL
		END;

	RETURN (@Result);
END