-- =================================================================================
-- Author       : jakemurx
-- Create date  : 2020-09-29 16:57:30.683
-- Description  : Creates the review statuses
-- Example      : EXEC [setup].[CreateReviewStatuses]
--                SELECT * FROM [ref].[ReviewStatuses]
-- =================================================================================
CREATE PROCEDURE [setup].[CreateReviewStatuses]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[ReviewStatuses]';
	BEGIN
		TRUNCATE TABLE [ref].[ReviewStatuses];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[ReviewStatuses] ON;

		INSERT [ref].[ReviewStatuses] ([Id], [Name]) VALUES (1, 'Approved');
		INSERT [ref].[ReviewStatuses] ([Id], [Name]) VALUES (2, 'Rejected');

		SET IDENTITY_INSERT [ref].[ReviewStatuses] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[ReviewStatuses] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR);
	PRINT @Message;
END
