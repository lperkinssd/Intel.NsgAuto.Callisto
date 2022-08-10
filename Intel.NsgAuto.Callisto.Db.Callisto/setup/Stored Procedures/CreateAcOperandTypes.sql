-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-12 14:25:10.030
-- Description  : Creates the auto checker operand types.
-- Example      : EXEC [setup].[CreateAcOperandTypes];
--                SELECT * FROM [ref].[AcOperandTypes] ORDER BY [Id];
-- ======================================================================================
CREATE PROCEDURE [setup].[CreateAcOperandTypes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[AcOperandTypes]';
	BEGIN
		TRUNCATE TABLE [ref].[AcOperandTypes];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[AcOperandTypes] ON;

		INSERT [ref].[AcOperandTypes] ([Id], [Name])
		VALUES
			  (1,  'None')
			, (2,  'Single Value')
			, (3,  'List');

		SET IDENTITY_INSERT [ref].[AcOperandTypes] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[AcOperandTypes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
