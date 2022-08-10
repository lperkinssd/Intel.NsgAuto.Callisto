-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-25 15:54:22.473
-- Description  : Creates the part use types
-- Example      : EXEC [setup].[CreatePartUseTypes];
--                SELECT * FROM [ref].[PartUseTypes];
-- =================================================================================
CREATE PROCEDURE [setup].[CreatePartUseTypes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[PartUseTypes]';
	BEGIN
		TRUNCATE TABLE [ref].[PartUseTypes];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[PartUseTypes] ON;

		INSERT [ref].[PartUseTypes] ([Id], [Name], [Abbreviation])
		VALUES
			  (1, 'Production', 'Prod')
			, (2, 'Engineering Sample', 'ES');

		SET IDENTITY_INSERT [ref].[PartUseTypes] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[PartUseTypes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
