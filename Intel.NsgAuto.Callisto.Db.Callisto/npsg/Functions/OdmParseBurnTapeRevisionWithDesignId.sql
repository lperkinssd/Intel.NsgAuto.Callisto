





-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [npsg].[OdmParseBurnTapeRevision]('123456')
-- SELECT [npsg].[OdmParseBurnTapeRevision]('>121')
-- SELECT [npsg].[OdmParseBurnTapeRevision]('>=2019004')
-- SELECT [npsg].[OdmParseBurnTapeRevision]('<121')
-- SELECT [npsg].[OdmParseBurnTapeRevision]('<=2019004')
-- SELECT [npsg].[OdmParseBurnTapeRevision]('=121')
-- =============================================
CREATE FUNCTION [npsg].[OdmParseBurnTapeRevisionWithDesignId]
(
		@DesignId VARCHAR(MAX),
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	--DECLARE @SqlClause VARCHAR(MAX) = ' CAST(Burn_Tape_Revision AS NUMERIC(10,2)) ' + [npsg].[FParseMATAttributes](@AttributeValue);
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

	IF (@DesignId NOT IN ('N38A', 'N38B'))
		SET @SqlClause = ' CAST(Burn_Tape_Revision AS NUMERIC(10,2)) ' + @AttributeValue;
	ELSE
		SET @SqlClause = ' CAST(SUBSTRING(Burn_Tape_Revision, 1, 3) AS NUMERIC(10,2)) ' + @AttributeValue;

	RETURN 	@SqlClause;

END