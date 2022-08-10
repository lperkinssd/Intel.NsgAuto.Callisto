

-- =================================================================================
-- Author       : jakemurx
-- Create date  : 2021-04-07 15:17:13.263
-- Description  : Creates the lot disposition actions for Odm QualFilter scenarios
-- Example      : EXEC [setup].[CreateOdmLotDispositionActions];
--                SELECT * FROM [ref].[OdmLotDispositionActions];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateOdmLotDispositionActions]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[OdmLotDispositionActions]';
	BEGIN
		TRUNCATE TABLE [ref].[OdmLotDispositionActions];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[OdmLotDispositionActions] ON;

		INSERT [ref].[OdmLotDispositionActions] ([Id], [ActionName], [DisplayText])
		VALUES
			  (1, 'Marked_Non_Qualified', 'Marked Non Qualified')
			, (2, 'Marked_Qualified', 'Marked Qualified');

		SET IDENTITY_INSERT [ref].[OdmLotDispositionActions] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[OdmLotDispositionActions] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END