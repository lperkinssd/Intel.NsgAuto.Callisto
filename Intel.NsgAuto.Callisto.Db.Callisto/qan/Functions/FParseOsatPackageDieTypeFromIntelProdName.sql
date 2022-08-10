-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2021-05-26 13:19:56.157
-- Description  : Parses out the package die type from the intel product name
-- Example      : SELECT [qan].[FParseOsatPackageDieTypeFromIntelProdName]('N38B 15DP 1920GB BGA 132 8CE FP');
-- ===============================================================================================================
CREATE FUNCTION [qan].[FParseOsatPackageDieTypeFromIntelProdName]
(
	  @IntelProdName  VARCHAR(100)
)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @Result VARCHAR(10) = LTRIM(SUBSTRING(@IntelProdName, CHARINDEX(' ', @IntelProdName), CHARINDEX(' ', LTRIM(SUBSTRING(@IntelProdName,CHARINDEX(' ', @IntelProdName), LEN(@IntelProdName) - CHARINDEX(' ', @IntelProdName))))));
	RETURN @Result;
END
