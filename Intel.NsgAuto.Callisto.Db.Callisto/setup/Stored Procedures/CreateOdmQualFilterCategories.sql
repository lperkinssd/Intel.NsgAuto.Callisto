

-- =================================================================================
-- Author       : jakemurx
-- Create date  : 2021-04-07 09:40:20.037
-- Description  : Creates the categories for Odm QualFilter scenarios
-- Example      : EXEC [setup].[CreateOdmQualFilterCategories];
--                SELECT * FROM [ref].[OdmLotDispositionReasons];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateOdmQualFilterCategories]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[OdmQualFilterCategories]';
	BEGIN
		TRUNCATE TABLE [ref].[OdmQualFilterCategories];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[OdmQualFilterCategories] ON;

		INSERT [ref].[OdmQualFilterCategories] ([Id], [Name])
		VALUES
			  (1, 'Non Qualified')
			, (2, 'Qualified');

		SET IDENTITY_INSERT [ref].[OdmQualFilterCategories] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[OdmQualFilterCategories] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END