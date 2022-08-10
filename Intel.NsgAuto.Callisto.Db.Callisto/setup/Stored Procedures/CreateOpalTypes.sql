-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-09 12:11:39.053
-- Description  : Creates the opal types
-- Example      : EXEC [setup].[CreateOpalTypes];
--                SELECT * FROM [ref].[OpalTypes];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateOpalTypes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[OpalTypes]';
	BEGIN
		TRUNCATE TABLE [ref].[OpalTypes];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[OpalTypes] ON;

		INSERT [ref].[OpalTypes] ([Id], [Name])
		VALUES
			  (1, 'OPAL')
			, (2, 'NON OPAL');

		SET IDENTITY_INSERT [ref].[OpalTypes] OFF
	END
	SELECT @Count = COUNT(*) FROM [ref].[OpalTypes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
