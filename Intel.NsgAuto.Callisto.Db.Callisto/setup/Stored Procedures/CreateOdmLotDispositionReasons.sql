

-- =================================================================================
-- Author       : jakemurx
-- Create date  : 2021-04-07 09:40:20.037
-- Description  : Creates the lot disposition reasons for Odm QualFilter scenarios
-- Example      : EXEC [setup].[CreateOdmLotDispositionReasons];
--                SELECT * FROM [ref].[OdmLotDispositionReasons];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateOdmLotDispositionReasons]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[OdmLotDispositionReasons]';
	BEGIN
		TRUNCATE TABLE [ref].[OdmLotDispositionReasons];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[OdmLotDispositionReasons] ON;

		INSERT [ref].[OdmLotDispositionReasons] ([Id], [Description])
		VALUES
			  (1, 'DOE Build')
			, (2, 'Mechanical Build')
			, (3, 'Missing Treadstone Attribute Data')
			, (4, 'Pipe-clean')
			, (5, 'Risk Approved – Please list approvers in notes')
			, (6, 'Waived Media')
			, (7, 'Bad Data Quality (Moved to Non-Qualified)')
			, (8, 'Lot moved out of WIP ')
			, (9, 'Media Attributes Condition(s) Not Met (Marked Non-Qualified)')
			, (10, 'Manual Disposition');

		SET IDENTITY_INSERT [ref].[OdmLotDispositionReasons] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[OdmLotDispositionReasons] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END