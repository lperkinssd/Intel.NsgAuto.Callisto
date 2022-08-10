-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-28 10:10:41.190
-- Description  : Creates the statuses
-- Example      : EXEC [setup].[CreateStatuses];
--                SELECT * FROM [ref].[Statuses];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateStatuses]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[Statuses]';
	BEGIN
		TRUNCATE TABLE [ref].[Statuses];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[Statuses] ON;

		INSERT [ref].[Statuses] ([Id], [Name])
		VALUES
			  (1, 'Draft')
			, (2, 'Canceled')
			, (3, 'Submitted')
			, (4, 'Rejected')
			, (5, 'In Review')
			, (6, 'Complete');

		SET IDENTITY_INSERT [ref].[Statuses] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[Statuses] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
