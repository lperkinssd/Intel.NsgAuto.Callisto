-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16 16:14:01.467
-- Description  : Creates the osat attribute data types and comparison associations
-- Example      : EXEC [setup].[CreateOsatAttributeDataTypeOperations];
--                SELECT * FROM [ref].[OsatAttributeDataTypeOperations];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateOsatAttributeDataTypeOperations]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[OsatAttributeDataTypeOperations]';
	BEGIN
		TRUNCATE TABLE [ref].[OsatAttributeDataTypeOperations];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		INSERT [ref].[OsatAttributeDataTypeOperations] ([AttributeDataTypeId], [ComparisonOperationId])
		VALUES
			-- string; AttributeDataTypeId = 1
			  (1, 1)   -- =
			, (1, 6)   -- >=
			, (1, 13)  -- in
			-- number; AttributeDataTypeId = 2
			, (2, 1)   -- =
			, (2, 6)   -- >=
			, (2, 13)  -- in
	END
	SELECT @Count = COUNT(*) FROM [ref].[OsatAttributeDataTypeOperations] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
