-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-12 09:38:04.707
-- Description  : Creates the speed item categories
-- Example      : EXEC [setup].[CreateSpeedItemCategories];
--                SELECT * FROM [ref].[SpeedItemCategories];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateSpeedItemCategories]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[SpeedItemCategories]';
	BEGIN
		TRUNCATE TABLE [ref].[SpeedItemCategories];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[SpeedItemCategories] ON;

		INSERT [ref].[SpeedItemCategories] ([Id], [Name], [Code])
		VALUES
			  (1, 'Product', 'PRODUCT')
			, (2, 'PCode', 'PCODE')
			, (3, 'SCode', 'SCODE')
			, (4, 'NAND/Media', 'NAND_MEDIA')
			, (5, 'TA', 'TA')
			, (6, 'SA', 'SA')
			, (7, 'PBA', 'PBA')
			, (8, 'AA', 'AA')
			, (9, 'Firmware', 'FIRMWARE');

		SET IDENTITY_INSERT [ref].[SpeedItemCategories] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[SpeedItemCategories] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
