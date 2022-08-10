-- ===========================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-30 12:08:54.610
-- Description  : The CreatedBy and UpdatedBy field value for records created from Speed data
-- Example      : SELECT [qan].[CreatedBySpeed]();
-- ===========================================================================================
CREATE FUNCTION [qan].[CreatedBySpeed]()
RETURNS VARCHAR(10)
AS
BEGIN
	RETURN 'SPEED';
END
