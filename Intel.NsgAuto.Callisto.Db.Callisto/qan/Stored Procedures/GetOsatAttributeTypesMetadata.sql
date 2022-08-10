-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-02-22 17:33:42.877
-- Description  : Gets osat attribute types for the manage view
-- Example      : EXEC [qan].[GetOsatAttributeTypesManage] 'bricschx';
-- =======================================================================
CREATE PROCEDURE [qan].[GetOsatAttributeTypesManage]
(
	  @UserId VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;

	-- record set #1: attribute types
	SELECT * FROM [qan].[FOsatAttributeTypes](NULL, NULL, NULL) ORDER BY [Name];

	-- record set #2: attribute data types
	SELECT * FROM [qan].[FOsatAttributeDataTypes](NULL, NULL) ORDER BY [Id];

	-- record set #3: comparison operations
	SELECT * FROM [qan].[FOsatComparisonOperations](NULL, NULL, 0, NULL, NULL) ORDER BY [Id];

	-- record set #4: data type comparison operations
	SELECT * FROM [ref].[OsatAttributeDataTypeOperations] WITH (NOLOCK) ORDER BY [AttributeDataTypeId], [ComparisonOperationId];

END
