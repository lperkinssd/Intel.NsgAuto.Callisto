-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-02 10:03:00.063
-- Description  : Executes all setup Create* procedures
-- Example      : EXEC [setup].[CreateAll]
-- =================================================================================
CREATE PROCEDURE [setup].[CreateAll]
AS
BEGIN
	SET NOCOUNT ON;

	EXEC [setup].[CreateTaskTypes];

END
