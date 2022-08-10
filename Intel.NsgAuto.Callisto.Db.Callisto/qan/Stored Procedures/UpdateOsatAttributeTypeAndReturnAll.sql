-- =========================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-22 17:41:47.787
-- Description  : Updates an osat attribute type and returns all of them
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatAttributeTypeAndReturnAll] NULL, @Message OUTPUT, 'bricschx', 1, 'test', 'Test', 0;
--                PRINT @Message; -- should print 'Data type is invalid: 0'
-- =========================================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatAttributeTypeAndReturnAll]
(
	  @Succeeded BIT OUTPUT
	, @Message VARCHAR(500) OUTPUT
	, @UserId VARCHAR(25)
	, @Id INT
	, @Name VARCHAR(50)
	, @NameDisplay VARCHAR(50)
	, @DataTypeId INT
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[UpdateOsatAttributeType] @Succeeded OUTPUT, @Message OUTPUT, @UserId, @Id, @Name, @NameDisplay, @DataTypeId;

	SELECT * FROM [qan].[FOsatAttributeTypes](NULL, NULL, NULL) ORDER BY [Name], [Id];

END
