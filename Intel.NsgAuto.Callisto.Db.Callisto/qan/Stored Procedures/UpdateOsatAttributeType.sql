-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-22 17:38:36.723
-- Description  : Updates an osat attribute type
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatAttributeType] NULL, @Message OUTPUT, 'bricschx', 1, 'test', 'Test', 0;
--                PRINT @Message; -- should print 'Data type is invalid: 0'
-- ===============================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatAttributeType]
(
	  @Succeeded   BIT          OUTPUT
	, @Message     VARCHAR(500) OUTPUT
	, @UserId      VARCHAR(25)
	, @Id          INT
	, @Name        VARCHAR(50)
	, @NameDisplay VARCHAR(50)
	, @DataTypeId  INT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionDescription VARCHAR (1000) = 'Update';
	DECLARE @DataTypeIdValid   INT;
	DECLARE @ErrorsExist       BIT = 0;
	DECLARE @IdValid           INT;

	SET @Succeeded = 0;
	SET @Message = NULL;

	-- begin standardization
	SET @Name = NULLIF(LOWER(RTRIM(LTRIM(@Name))), '');
	SET @NameDisplay = NULLIF(RTRIM(LTRIM(@NameDisplay)), '');
	-- end standardization

	SET @ActionDescription = @ActionDescription + '; Name = ' + ISNULL(@Name, 'null')
												+ '; NameDisplay = ' + ISNULL(@NameDisplay, 'null')
												+ '; DataTypeId = ' + ISNULL(CAST(@DataTypeId AS VARCHAR(20)), 'null');

	-- begin validation
	SELECT @IdValid = MAX([Id]) FROM [qan].[OsatAttributeTypes] WITH (NOLOCK) WHERE [Id] = @Id;
	SELECT @DataTypeIdValid = MAX([Id]) FROM [ref].[OsatAttributeDataTypes] WITH (NOLOCK) WHERE [Id] = @DataTypeId;

	IF (@Name IS NULL)
	BEGIN
		SET @Message = 'Name is required';
		SET @ErrorsExist = 1;
	END
	ELSE IF (@NameDisplay IS NULL)
	BEGIN
		SET @Message = 'Display Name is required';
		SET @ErrorsExist = 1;
	END
	ELSE IF (@IdValid IS NULL)
	BEGIN
		SET @Message = 'Attribute id is invalid: ' + ISNULL(CAST(@Id AS VARCHAR(20)), 'null');
		SET @ErrorsExist = 1;
	END
	ELSE IF (EXISTS (SELECT 1 FROM [qan].[OsatAttributeTypes] WITH (NOLOCK) WHERE [Name] = @Name AND [Id] <> @Id))
	BEGIN
		SET @Message = 'Name already in use';
		SET @ErrorsExist = 1;
	END
	ELSE IF (EXISTS (SELECT 1 FROM [qan].[OsatAttributeTypes] WITH (NOLOCK) WHERE [NameDisplay] = @NameDisplay AND [Id] <> @Id))
	BEGIN
		SET @Message = 'Display Name already in use';
		SET @ErrorsExist = 1;
	END
	ELSE IF (@DataTypeIdValid IS NULL)
	BEGIN
		SET @Message = 'Data Type is invalid: ' + ISNULL(CAST(@DataTypeId AS VARCHAR(20)), 'null');
		SET @ErrorsExist = 1;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		UPDATE [qan].[OsatAttributeTypes] SET
			  [Name] = @Name
			, [NameDisplay] = @NameDisplay
			, [DataTypeId] = @DataTypeId
			, [UpdatedBy] = @UserId
			, [UpdatedOn] = GETUTCDATE()
		WHERE [Id] = @Id;

		SET @Succeeded = 1;
	END;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', 'Update', 'OsatAttributeType', @Id, NULL, @Succeeded, @Message;

END
