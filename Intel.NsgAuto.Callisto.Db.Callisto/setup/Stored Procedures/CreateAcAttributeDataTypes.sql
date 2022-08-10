-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-11 14:34:44.167
-- Description  : Creates the auto checker attribute data types
-- Example      : EXEC [setup].[CreateAcAttributeDataTypes];
--                SELECT * FROM [ref].[AcAttributeDataTypes];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateAcAttributeDataTypes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[AcAttributeDataTypes]';
	BEGIN
		TRUNCATE TABLE [ref].[AcAttributeDataTypes];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[AcAttributeDataTypes] ON;

		INSERT [ref].[AcAttributeDataTypes] ([Id], [Name], [NameDisplay])
		VALUES
			  (1, 'string', 'String')
			, (2, 'number', 'Number');

		SET IDENTITY_INSERT [ref].[AcAttributeDataTypes] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[AcAttributeDataTypes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
