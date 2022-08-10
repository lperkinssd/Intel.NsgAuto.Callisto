




-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [qan].[OdmParseBurnTapeRevision]('123456')
-- SELECT [qan].[OdmParseBurnTapeRevision]('>121')
-- SELECT [qan].[OdmParseBurnTapeRevision]('>=2019004')
-- SELECT [qan].[OdmParseBurnTapeRevision]('<121')
-- SELECT [qan].[OdmParseBurnTapeRevision]('<=2019004')
-- SELECT [qan].[OdmParseBurnTapeRevision]('=121')
-- =============================================
CREATE FUNCTION [qan].[OdmParseBurnTapeRevision]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	--DECLARE @SqlClause VARCHAR(MAX) = ' CAST(Burn_Tape_Revision AS NUMERIC(10,2)) ' + [qan].[FParseMATAttributes](@AttributeValue);
	--RETURN @SqlClause;

	--Declare the return variable here
	DECLARE @SqlClause VARCHAR(MAX)

	-- There will never be a list, NULL, 'NULL', '', or an operator
	-- There should never be an operator but... just in case
	-- remove the operator before continuing
	IF CHARINDEX('>=', @AttributeValue) > 0
		SET @AttributeValue = ' < CAST(''' + REPLACE(@AttributeValue, '>=', '') + ''' AS NUMERIC(10,2)) ';

	ELSE IF CHARINDEX('<=', @AttributeValue) > 0
		SET @AttributeValue = ' > CAST(''' + REPLACE(@AttributeValue, '<=', '') + ''' AS NUMERIC(10,2)) ';

	ELSE IF CHARINDEX('>', @AttributeValue) > 0
		SET @AttributeValue = ' <= CAST(''' + REPLACE(@AttributeValue, '>', '') + ''' AS NUMERIC(10,2)) ';

	ELSE IF CHARINDEX('<', @AttributeValue) > 0
		SET @AttributeValue = ' >= CAST(''' + REPLACE(@AttributeValue, '<', '') + ''' AS NUMERIC(10,2)) ';

	ELSE IF CHARINDEX('=', @AttributeValue) > 0
		SET @AttributeValue = ' <> CAST(''' + REPLACE(@AttributeValue, '=', '') + ''' AS NUMERIC(10,2)) ';

	ELSE -- No operator
		SET @AttributeValue = ' < CAST(''' + @AttributeValue + ''' AS NUMERIC(10,2)) ';

	SET @SqlClause = ' CAST(Burn_Tape_Revision AS NUMERIC(10,2)) ' + @AttributeValue;

	RETURN 	@SqlClause;

END