



-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [qan].[FParseMATAttributes]('>=121')
-- =============================================
CREATE FUNCTION [qan].[OdmCleanMediaAttributeValue] 
(
       @AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN
       -- Declare the return variable here
       DECLARE @CleanValue VARCHAR(MAX)
       
	   SET @CleanValue = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@AttributeValue, '>=', ''), '<=', ''), '>', ''), '<', ''), '=', ''), '<>', '');
		
       -- Return the result of the function
       RETURN @CleanValue;

END