-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16 16:04:29.783
-- Description  : Creates the osat comparison operations. The keys are designed to work
--                with the DevExtreme filter builder (either already supported, or we
--                designed custom code for them). So don't change or alter keys unless
--                you understand all ramifications. The names agre with the text
--                supported by the filter builder, so it is not advisable to change them
--                as it may result in inconsistent names with what is displayed by the
--                filter builder.
-- Example      : EXEC [setup].[CreateOsatComparisonOperations];
--                SELECT * FROM [ref].[OsatComparisonOperations];
-- ======================================================================================
CREATE PROCEDURE [setup].[CreateOsatComparisonOperations]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[OsatComparisonOperations]';
	BEGIN
		TRUNCATE TABLE [ref].[OsatComparisonOperations];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[OsatComparisonOperations] ON;

		-- OperandTypeId: 1 => None
		-- OperandTypeId: 2 => Single Value
		-- OperandTypeId: 3 => List
		INSERT [ref].[OsatComparisonOperations] ([Id], [Key], [Name], [OperandTypeId])
		VALUES
			  (1,  '=', 'Equals', 2)
			, (2,  '<>', 'Does not equal', 2)
			, (3,  '<', 'Is less than', 2)
			, (4,  '>', 'Is greater than', 2)
			, (5,  '<=', 'Is less than or equal to', 2)
			, (6,  '>=', 'Is greater than or equal to', 2)
			, (7,  'contains', 'Contains', 2)
			, (8,  'notcontains', 'Does not contain', 2)
			, (9,  'startswith', 'Starts with', 2)
			, (10, 'endswith', 'Ends with', 2)
			, (11, 'isblank', 'Is blank', 1)
			, (12, 'isnotblank', 'Is not blank', 1)
			, (13, 'in', 'Is in', 3)
			, (14, 'notin', 'Is not in', 3)

		SET IDENTITY_INSERT [ref].[OsatComparisonOperations] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[OsatComparisonOperations] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
