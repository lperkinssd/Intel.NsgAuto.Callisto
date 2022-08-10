-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-11 14:41:48.327
-- Description  : Creates the auto checker comparison operations. The keys are designed
--                to work with the DevExtreme filter builder (either already supported,
--                or we designed custom code for them). So don't change or alter keys
--                unless you understand all ramifications. There is a KeyTreadstone field
--                so we can pass the treadstone system the operation it wants which may
--                be different from what the filter builder needs. Example: 'notcontains'
--                (filter builder) vs 'does not contain' (treadstone). Also note that the
--                names agree with the text supported by the filter builder, so it is not
--                advisable to change them as it may result in inconsistent names with
--                what is displayed by the filter builder.
-- Example      : EXEC [setup].[CreateAcComparisonOperations];
--                SELECT * FROM [ref].[AcComparisonOperations];
-- ======================================================================================
CREATE PROCEDURE [setup].[CreateAcComparisonOperations]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[AcComparisonOperations]';
	BEGIN
		TRUNCATE TABLE [ref].[AcComparisonOperations];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[AcComparisonOperations] ON;

		-- OperandTypeId: 1 => None
		-- OperandTypeId: 2 => Single Value
		-- OperandTypeId: 3 => List
		INSERT [ref].[AcComparisonOperations] ([Id], [Key], [KeyTreadstone], [Name], [OperandTypeId])
		VALUES
			  (1,  '=', '=', 'Equals', 2)
			, (2,  '<>', '<>', 'Does not equal', 2)                           -- treadstone may not support
			, (3,  '<', '<', 'Is less than', 2)                               -- treadstone may not support
			, (4,  '>', '>', 'Is greater than', 2)                            -- treadstone may not support
			, (5,  '<=', '<=', 'Is less than or equal to', 2)                 -- treadstone may not support
			, (6,  '>=', '>=', 'Is greater than or equal to', 2)
			, (7,  'contains', 'contains', 'Contains', 2)
			, (8,  'notcontains', 'does not contain', 'Does not contain', 2)
			, (9,  'startswith', 'startswith', 'Starts with', 2)              -- treadstone may not support
			, (10, 'endswith', 'endswith', 'Ends with', 2)                    -- treadstone may not support
			, (11, 'isblank', 'isblank', 'Is blank', 1)                       -- treadstone may not support
			, (12, 'isnotblank', 'isnotblank', 'Is not blank', 1)             -- treadstone may not support
			, (13, 'in', 'in', 'Is in', 3)                                    -- custom DevExtreme filter builder logic
			, (14, 'notin', 'not in', 'Is not in', 3)                         -- custom DevExtreme filter builder logic

		SET IDENTITY_INSERT [ref].[AcComparisonOperations] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[AcComparisonOperations] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
