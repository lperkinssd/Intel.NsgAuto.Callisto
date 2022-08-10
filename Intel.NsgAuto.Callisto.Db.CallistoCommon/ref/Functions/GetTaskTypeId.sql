-- ============================================================================
-- Author       : bricschx
-- Create date  : 2020-09-17 13:27:43.140
-- Description  : Gets the id of the task type with the given name
-- Example      : SELECT [ref].[GetTaskTypeId]('Speed Pull');
-- ============================================================================
CREATE FUNCTION [ref].[GetTaskTypeId]
(
	@Name VARCHAR(100)
)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT;

	SELECT @Result = MAX([Id]) FROM [ref].[TaskTypes] WITH (NOLOCK) WHERE [Name] = @Name;

	RETURN (@Result);
END;
