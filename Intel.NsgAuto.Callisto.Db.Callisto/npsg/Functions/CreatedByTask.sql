-- ==============================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-11 15:50:13.573
-- Description  : The CreatedBy and UpdatedBy field value for records created from a system task
-- Example      : 
-- =============================================================================================
CREATE FUNCTION [npsg].[CreatedByTask](@TaskId BIGINT)
RETURNS VARCHAR(25)
AS
BEGIN
	RETURN 'TASK_' + CAST(@TaskId AS VARCHAR(20));
END