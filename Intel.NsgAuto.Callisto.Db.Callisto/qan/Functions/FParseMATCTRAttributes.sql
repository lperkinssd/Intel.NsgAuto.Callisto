

-- =============================================
-- Author:      jakemurx
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [qan].[FParseMATAttributes](NULL)
-- SELECT [qan].[FParseMATAttributes]('NULL')
-- SELECT [qan].[FParseMATAttributes]('WAVE019')
-- SELECT [qan].[FParseMATAttributes]('N38A00 N A')
-- SELECT [qan].[FParseMATAttributes]('7.77/7.82/7.83')
-- SELECT [qan].[FParseMATAttributes]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [qan].[FParseMATAttributes]('>=121')
-- SELECT [qan].[FParseMATAttributes]('=121')
-- =============================================
CREATE FUNCTION [qan].[FParseMATCTRAttributes] 
(
       @AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN
       -- Declare the return variable here
       DECLARE @SqlClause VARCHAR(MAX)
       DECLARE @Operator varchar(2)
       DECLARE @IndexOf int
       DECLARE @Substring varchar(50)

	   -- Check if it is a list of values
	   IF CHARINDEX('/',@AttributeValue) > 0 
		BEGIN
			-- If there is /, then it is a list of values
			SET @IndexOf = CHARINDEX('/', @AttributeValue);
			SET @Substring = SUBSTRING(@AttributeValue, 0, @IndexOf);
			----IF ISNUMERIC(@Substring) > 0
			----BEGIN
			----	-- it is numeric, so just get the vlues separated by ,
			----	-- result will be  NOT IN (7.77,7.82,7.83) 
			----	SET @SqlClause = ' NOT IN (' +  replace(@AttributeValue, '/', ',') + ') ';    
			----END            
			----ELSE
			----BEGIN 
				-- it is a string, so each value needs to be wrapped with ' and a comma needs to be added
				-- result will be NOT IN ('PRB_06','PRB 06','PRB_08','PRB 08','PRB_10','PRB 10','PRB_14','PRB 14','PRB_15','PRB 15') 		
				SET @SqlClause = ' NOT IN (''' +  replace(@AttributeValue, '/', ''',''') + ''') ';						 
			----END     
		END
		ELSE
		BEGIN
			-- okay, so it is not a list of values! So we expect a value which may or may not have an operator, unless it is NULL or 'NULL' 
			-- If attribute value is NULL in media attributes, we should do exact opposite, So do 'IS NOT NULL'
			IF @AttributeValue IS NULL OR @AttributeValue = 'NULL'
			BEGIN
				SET @SqlClause = ' NOT IN (''NULL'') '; 
			END
			--ELSE IF @AttributeValue = 'NULL'
			--BEGIN
			--	SET @SqlClause = ' NOT IN ('') '; 
			--END	
			--ELSE IF @AttributeValue = ''
			--BEGIN
			--	SET @SqlClause = ' < '''' '; 
			--END		
			ELSE IF @AttributeValue = ''
			BEGIN
				SET @SqlClause = ' <> '''' '; 
			END
			ELSE IF CHARINDEX('>=', @AttributeValue) > 0
				SET @SqlClause = ' < ''' + REPLACE(@AttributeValue, '>=', '') + '''';

			ELSE IF CHARINDEX('<=', @AttributeValue) > 0
				SET @SqlClause = ' > ''' + replace(@AttributeValue, '<=', '') + '''';

			ELSE IF CHARINDEX('>', @AttributeValue) > 0
				SET @SqlClause = ' <= ''' + replace(@AttributeValue, '>', '') + '''';

			ELSE IF CHARINDEX('<', @AttributeValue) > 0
				SET @SqlClause = ' >=  ''' + replace(@AttributeValue, '<', '') + '''';

			ELSE IF CHARINDEX('=', @AttributeValue) > 0
			BEGIN 
				--IF ISNUMERIC(@AttributeValue) > 0
				--	SET @SqlClause = ' <> ' + @AttributeValue;
				--ELSE
				SET @SqlClause = ' <>  ''' + replace(@AttributeValue, '=', '') + '''';
			END             
			ELSE
			BEGIN 
				----IF ISNUMERIC(@AttributeValue) > 0
				----	SET @SqlClause = ' NOT IN (' + @AttributeValue + ') '; 
				----ELSE
					SET @SqlClause = ' NOT IN (''' + @AttributeValue + ''') ';
					--SET @SqlClause = ' < ''' + @AttributeValue + ''' ';
			END
		END	   

       -- Return the result of the function
       RETURN @SqlClause;

END