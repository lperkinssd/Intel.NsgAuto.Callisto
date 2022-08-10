
-- ============================================================================
-- Author       : jkurian
-- Create Date  : 2021-03-09 10:30:41.310
-- Description  : Converts the string value to numeric
--					SELECT [qan].[ToNumeric]('029')
--					SELECT [qan].[ToNumeric]('>29')
--					SELECT [qan].[ToNumeric]('32}')
--					SELECT [qan].[ToNumeric]('32.')
--					SELECT [qan].[ToNumeric]('032.')
-- ============================================================================
CREATE FUNCTION [qan].[ToNumeric]
(
	@Val  VARCHAR(255) 
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Result NUMERIC(10,2);
	
	SELECT @Result = (
		SELECT 
			CASE WHEN ISNUMERIC(@Val)=0 THEN CAST(LEFT(@Val,PATINDEX('%[^.0-9]%',@Val)-1) AS NUMERIC(10,2))
			ELSE CAST(@Val AS NUMERIC(10,2))
			END
	);

	RETURN (@Result);
END;