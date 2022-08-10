


-- ==================================================================================================================================================
-- Author       : ftianx
-- Create date  : 2021-09-01 12:58:28.108
-- Description  : Save the newly selected preferred role for the user
-- Example      : DECLARE @newActiveRole VARCHAR(50) = 'NPSG'
--                DECLARE @userId VARCHAR(50) = 'ftianx';
--                
--                EXEC [qan].[SavePreferredRole] @userId, @newActiveRole 
 -- ==================================================================================================================================================
CREATE PROCEDURE [qan].[SavePreferredRole]
(
	@userId             VARCHAR(50)
	, @newActiveRole    VARCHAR(50) 
)
AS
BEGIN
	SET NOCOUNT ON;

	IF (SELECT COUNT(*) FROM [qan].[PreferredRole] WITH (NOLOCK) WHERE [UserId] = @userId) > 0
	BEGIN
		UPDATE [qan].[PreferredRole]
		SET 
		  [ActiveRole] = @newActiveRole
		  ,[UpdatedOn] = GETDATE()
		WHERE [UserId] = @userId
	END
	ELSE
	BEGIN
		INSERT INTO [qan].[PreferredRole]
			   ([UserId]
			   ,[ActiveRole]
			   ,[CreatedOn]
			   ,[UpdatedOn])
		 VALUES
			   (@userId
			   ,@newActiveRole
			   ,GETDATE()
			   ,GETDATE())
	END
END