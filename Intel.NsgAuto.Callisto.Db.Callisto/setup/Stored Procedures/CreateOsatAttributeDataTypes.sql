-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16 16:11:26.353
-- Description  : Creates the osat attribute data types
-- Example      : EXEC [setup].[CreateOsatAttributeDataTypes];
--                SELECT * FROM [ref].[OsatAttributeDataTypes];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateOsatAttributeDataTypes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[OsatAttributeDataTypes]';
	BEGIN
		TRUNCATE TABLE [ref].[OsatAttributeDataTypes];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[OsatAttributeDataTypes] ON;

		INSERT [ref].[OsatAttributeDataTypes] ([Id], [Name], [NameDisplay])
		VALUES
			  (1, 'string', 'String')
			, (2, 'number', 'Number');

		SET IDENTITY_INSERT [ref].[OsatAttributeDataTypes] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[OsatAttributeDataTypes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
