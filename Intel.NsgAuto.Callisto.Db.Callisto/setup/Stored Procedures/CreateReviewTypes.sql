-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-06 14:17:04.230
-- Description  : Creates the review types
-- Example      : EXEC [setup].[CreateReviewTypes] 'bricschx';
--                SELECT * FROM [ref].[ReviewTypes];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateReviewTypes]
(
	  @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[ReviewTypes]';
	IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	BEGIN
		TRUNCATE TABLE [ref].[ReviewTypes];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[ReviewTypes] ON;

		INSERT [ref].[ReviewTypes] ([Id], [Description], [CreatedBy], [UpdatedBy])
		VALUES
			  (1, 'Product Label Set Version', @By, @By)
			, (2, 'Material Attribute Table Version', @By, @By)
			, (3, 'MM Recipe', @By, @By)
			, (4, 'Auto Checker Build Criteria NAND', @By, @By)
			, (6, 'Osat Build Criteria Set NAND', @By, @By);

		SET IDENTITY_INSERT [ref].[ReviewTypes] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[ReviewTypes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
