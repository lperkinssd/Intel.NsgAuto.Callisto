-- =============================================
-- Author:		jakemurx
-- Create date: 2020-09-18 15:33:25.798
-- Description:	Get MAT data type from the value
-- =============================================
CREATE FUNCTION [qan].[GetMATDataTypeFromValue] 
(
	-- Add the parameters for the function here
	@AttributeValue varchar(max)
)
RETURNS varchar(10)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(10)
	DECLARE @DataType varchar(255)

	-- Add the T-SQL statements to compute the return value here
	IF ISNUMERIC(@AttributeValue) = 1
	BEGIN
		IF (SELECT CHARINDEX('.', @AttributeValue)) > 0
			SET @DataType = 'decimal'
		ELSE
			SET @DataType = 'int'
	END
	ELSE
		SET @DataType = 'text'
	SELECT @Result = @DataType

	-- Return the result of the function
	RETURN @Result

END