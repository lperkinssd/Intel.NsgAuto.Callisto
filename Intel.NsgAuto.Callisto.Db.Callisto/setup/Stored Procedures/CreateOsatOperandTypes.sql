-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16 16:01:33.877
-- Description  : Creates the osat operand types.
-- Example      : EXEC [setup].[CreateOsatOperandTypes];
--                SELECT * FROM [ref].[OsatOperandTypes] ORDER BY [Id];
-- ======================================================================================
CREATE PROCEDURE [setup].[CreateOsatOperandTypes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[OsatOperandTypes]';
	BEGIN
		TRUNCATE TABLE [ref].[OsatOperandTypes];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[OsatOperandTypes] ON;

		INSERT [ref].[OsatOperandTypes] ([Id], [Name])
		VALUES
			  (1,  'None')
			, (2,  'Single Value')
			, (3,  'List');

		SET IDENTITY_INSERT [ref].[OsatOperandTypes] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[OsatOperandTypes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
