-- =========================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-11 15:01:53.370
-- Description  : Creates the auto checker attribute data types and comparison associations
-- Example      : EXEC [setup].[CreateAcAttributeDataTypeOperations];
--                SELECT * FROM [ref].[AcAttributeDataTypeOperations];
-- =========================================================================================
CREATE PROCEDURE [setup].[CreateAcAttributeDataTypeOperations]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[AcAttributeDataTypeOperations]';
	BEGIN
		TRUNCATE TABLE [ref].[AcAttributeDataTypeOperations];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		INSERT [ref].[AcAttributeDataTypeOperations] ([AttributeDataTypeId], [ComparisonOperationId])
		VALUES
			-- string; AttributeDataTypeId = 1
			  (1, 1)   -- =
			, (1, 6)   -- >=
			, (1, 7)   -- contains
			, (1, 8)   -- notcontains
			, (1, 13)  -- in
			, (1, 14)  -- notin
			-- number; AttributeDataTypeId = 2
			, (2, 1)   -- =
			, (2, 6)   -- >=
			, (2, 13)  -- in
			, (2, 14); -- notin
	END
	SELECT @Count = COUNT(*) FROM [ref].[AcAttributeDataTypeOperations] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
