-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-28 15:43:57.920
-- Description  : Creates the PLC stages
-- Example      : EXEC [setup].[CreatePLCStages];
--                SELECT * FROM [ref].[PLCStages];
-- =================================================================================
CREATE PROCEDURE [setup].[CreatePLCStages]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[PLCStages]';
	BEGIN
		TRUNCATE TABLE [ref].[PLCStages];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[PLCStages] ON;

		INSERT [ref].[PLCStages] ([Id], [Name])
		VALUES
			  (1, 'ES2')
			, (2, 'PRQ')
			, (3, 'LVM')
			, (4, 'HVM');

		SET IDENTITY_INSERT [ref].[PLCStages] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[PLCStages] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
