

-- ==================================================================================================================================================
-- Author       : ftianx
-- Create date  : 2021-09-01 12:58:28.108
-- Description  : Get the current preferred role for the user
-- Example      : DECLARE @activeRole VARCHAR(50)
--                DECLARE @userId VARCHAR(50) = 'ftianx';
--                
--                EXEC [qan].[GetPreferredRole] @userId, @activeRole OUTPUT
--                SELECT @activeRole;
--               
-- ==================================================================================================================================================
CREATE PROCEDURE [qan].[GetPreferredRole]
(
	@userId               VARCHAR(50)
	, @activeRole         VARCHAR(50) OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT @activeRole = [ActiveRole] FROM [qan].[PreferredRole] WITH (NOLOCK) WHERE [UserId] = @userId;

	IF @activeRole IS NULL
	BEGIN
		-- Default to empty to accommodate AutoChecker and OSAT
		SET @activeRole = '';
	END
END