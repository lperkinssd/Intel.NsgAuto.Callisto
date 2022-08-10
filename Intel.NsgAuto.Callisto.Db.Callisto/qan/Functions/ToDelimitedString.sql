-- ============================================================================
-- Author       : bricschx
-- Create Date  : 2021-03-09 10:30:41.310
-- Description  : Converts the table of strings into a single delimited string
-- Example      : DECLARE @Strings [qan].[IStrings];
--                INSERT INTO @Strings SELECT '1' UNION SELECT '2';
--                SELECT [qan].ToDelimitedString(@Strings, default, default);
-- ============================================================================
CREATE FUNCTION [qan].[ToDelimitedString]
(
	  @Strings    [qan].[IStrings] READONLY
	, @Delimeter  VARCHAR(10) = ','
	, @EncloseIn  VARCHAR(10) = ''
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Result VARCHAR(MAX);
	DECLARE @Temp VARCHAR(50) = @EncloseIn + @Delimeter + @EncloseIn;
	DECLARE @Length INT = LEN(@Temp);

	-- SELECT @Result = @EncloseIn + STRING_AGG([Value], @Temp) + @EncloseIn FROM (SELECT DISTINCT * FROM @Strings) AS T;
	-- changed from above to be compatible with Sql Server 2016
	SELECT @Result = @EncloseIn + STUFF((SELECT @Temp + [Value] FROM @Strings FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, @Length, '') + @EncloseIn;

	RETURN (@Result);
END;
