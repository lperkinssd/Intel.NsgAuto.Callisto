-- =============================================
-- Author:		jakemurx
-- Create date: 2021-04-07 09:26:34.993
-- Description:	Create ODM Names
-- EXEC [setup].[CreateOdmNames] 
-- =============================================
CREATE PROCEDURE [setup].[CreateOdmNames] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[Odms]';
	BEGIN
		TRUNCATE TABLE [ref].[Odms];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[Odms] ON;

		INSERT [ref].[Odms] ([Id], [Name])
		VALUES
			  (1, 'KINGSTON')
			, (2, 'PEGATRON')
			, (3, 'PTI');

		SET IDENTITY_INSERT [ref].[Odms] OFF
	END
	SELECT @Count = COUNT(*) FROM [ref].[Odms] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END