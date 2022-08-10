-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-28 15:48:03.730
-- Description  : Creates the design families
-- Example      : EXEC [setup].[CreateDesignFamilies];
--                SELECT * FROM [ref].[DesignFamilies];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateDesignFamilies]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[DesignFamilies]';
	BEGIN
		TRUNCATE TABLE [ref].[DesignFamilies];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[DesignFamilies] ON;

		INSERT [ref].[DesignFamilies] ([Id], [Name])
		VALUES
			  (1, 'NAND');

		SET IDENTITY_INSERT [ref].[DesignFamilies] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[DesignFamilies] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
