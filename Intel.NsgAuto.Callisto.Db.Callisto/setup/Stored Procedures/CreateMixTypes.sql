-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-04-28 16:00:21.153
-- Description  : Creates the mix types
-- Example      : EXEC [setup].[CreateMixTypes];
--                SELECT * FROM [ref].[MixTypes];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateMixTypes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[MixTypes]';
	BEGIN
		TRUNCATE TABLE [ref].[MixTypes];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[MixTypes] ON;

		INSERT [ref].[MixTypes] ([Id], [Name], [Abbreviation])
		VALUES
			  (1, 'Production Only', 'Prod')
			, (2, 'Engineering Samples Only', 'ES')
			, (3, 'Both Production And Engineering Samples', 'Both');

		SET IDENTITY_INSERT [ref].[MixTypes] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[MixTypes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
