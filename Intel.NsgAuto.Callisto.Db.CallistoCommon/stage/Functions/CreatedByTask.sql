-- ==============================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-20 17:32:43.430
-- Description  : The CreatedBy and UpdatedBy field value for records created from a system task
-- Example      : SELECT [stage].[CreatedByTask](1);
-- ==============================================================================================
CREATE FUNCTION [stage].[CreatedByTask](@TaskId BIGINT)
RETURNS VARCHAR(25)
AS
BEGIN
	RETURN 'TASK_' + CAST(@TaskId AS VARCHAR(20));
END
