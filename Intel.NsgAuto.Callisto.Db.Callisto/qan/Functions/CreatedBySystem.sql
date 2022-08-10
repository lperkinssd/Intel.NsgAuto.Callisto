-- =================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-11 16:10:21.207
-- Description  : The CreatedBy and UpdatedBy field value for records created from system processes
-- Example      : SELECT [qan].[CreatedBySystem]();
-- =================================================================================================
CREATE FUNCTION [qan].[CreatedBySystem]()
RETURNS VARCHAR(25)
AS
BEGIN
	RETURN 'SYSTEM';
END
