-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-28 15:48:03.730
-- Description  : Creates the customer qual statuses
-- Example      : EXEC [setup].[CreateCustomerQualStatuses];
--                SELECT * FROM [ref].[CustomerQualStatuses];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateCustomerQualStatuses]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[CustomerQualStatuses]';
	BEGIN
		TRUNCATE TABLE [ref].[CustomerQualStatuses];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[CustomerQualStatuses] ON;

		INSERT [ref].[CustomerQualStatuses] ([Id], [Name])
		VALUES
			  (1, 'PRQ')
			, (2, 'OEM Qual Scheduled');

		SET IDENTITY_INSERT [ref].[CustomerQualStatuses] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[CustomerQualStatuses] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
