
-- =================================================================================
-- Author       : jkurian
-- Create date  : 2020-09-28 10:10:41.190
-- Description  : Creates the processes and configures process specfic AD roles
-- Example      : EXEC [setup].[ConfigureProcessAndSecurity];
--                SELECT * FROM [qan].[ProcessRoles];
--                SELECT * FROM [ref].[Processes];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateProcessAndSecurity]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	-- Create process aka design family entries
	DECLARE @TableName VARCHAR(100) = '[ref].[Processes]';
	BEGIN
		TRUNCATE TABLE [ref].[Processes]
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		INSERT [ref].[Processes] ([Name], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) 
		VALUES (N'NAND', 1, N'system', CAST(N'2021-05-04T00:00:00.0000000' AS DateTime2), N'system', CAST(N'2021-05-04T00:00:00.0000000' AS DateTime2));

	 
	END
	SELECT @Count = COUNT(*) FROM [ref].[Processes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;

	-- Create process roles that are configured in AGS
	SET @TableName = '[qan].[ProcessRoles] ';
	BEGIN
		TRUNCATE TABLE [qan].[ProcessRoles] 
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		INSERT [qan].[ProcessRoles] ([Process], [RoleName]) VALUES (N'NAND', N'Callisto_Nand_User');
		
	END
	SELECT @Count = COUNT(*) FROM [qan].[ProcessRoles] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;

END