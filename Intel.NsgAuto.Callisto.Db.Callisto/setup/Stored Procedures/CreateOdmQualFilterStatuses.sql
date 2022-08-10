
-- =================================================================================
-- Author       : jakemurx
-- Create date  : 2021-04-21 09:10:23.747
-- Description  : Creates the statuses
-- Example      : EXEC [setup].[CreateOdmQualFilterStatuses];
--                SELECT * FROM [ref].[OdmQualFilterStatuses];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateOdmQualFilterStatuses]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[OdmQualFilterStatuses]';
	BEGIN
		TRUNCATE TABLE [ref].[OdmQualFilterStatuses];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[OdmQualFilterStatuses] ON;

		INSERT [ref].[OdmQualFilterStatuses] ([Id], [Name])
		VALUES
			  (1, 'Current')
			, (2, 'Modified')
			, (3, 'Published');

		SET IDENTITY_INSERT [ref].[OdmQualFilterStatuses] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[OdmQualFilterStatuses] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END