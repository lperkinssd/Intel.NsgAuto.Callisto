-- ==========================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-22 17:26:27.480
-- Description  : Creates a new osat attribute type and returns all of them
-- Example      : EXEC [qan].[CreateOsatAttributeTypeAndReturnAll] NULL, NULL, 'bricschx', 'test', 'Test', 1;
-- ==========================================================================================================
CREATE PROCEDURE [qan].[CreateOsatAttributeTypeAndReturnAll]
(
	  @Succeeded BIT OUTPUT
	, @Message VARCHAR(500) OUTPUT
	, @UserId VARCHAR(25)
	, @Name VARCHAR(50)
	, @NameDisplay VARCHAR(50)
	, @DataTypeId INT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Id INT;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[CreateOsatAttributeType] @Id OUTPUT, @Message OUTPUT, @UserId, @Name, @NameDisplay, @DataTypeId;

	IF (@Id IS NOT NULL) SET @Succeeded = 1;

	SELECT * FROM [qan].[FOsatAttributeTypes](NULL, NULL, NULL) ORDER BY [Name], [Id];

END
