-- ==========================================================================================================
-- Author       : bricschx
-- Create date  : 2021-07-30 12:34:41.143
-- Description  : Returns the user id supplied unless it is a system user id in which case NULL is returned.
-- Example      : SELECT [qan].[FixSystemUserId]('TASK_10');
-- ==========================================================================================================
CREATE FUNCTION [qan].[FixSystemUserId](@UserId VARCHAR(25))
RETURNS VARCHAR(25)
AS
BEGIN
	RETURN
		CASE
			WHEN @UserId =    'SYSTEM' THEN NULL
			WHEN @UserId LIKE 'TASK%'  THEN NULL
			ELSE @UserId
		END;
END
