-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-29 12:15:15.883
-- Description  : The CreatedBy and UpdatedBy field value for records created from Treadstone data
-- Example      : SELECT [qan].[CreatedByTreadstone]();
-- ================================================================================================
CREATE FUNCTION [qan].[CreatedByTreadstone]()
RETURNS VARCHAR(10)
AS
BEGIN
	RETURN 'TREADSTONE';
END
