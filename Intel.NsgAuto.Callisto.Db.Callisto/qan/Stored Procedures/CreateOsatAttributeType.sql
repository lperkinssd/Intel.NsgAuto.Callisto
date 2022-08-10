-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-22 17:21:16.697
-- Description  : Creates a new osat attribute type
-- Example      : EXEC [qan].[CreateOsatAttributeType] NULL, NULL, 'bricschx', 'test', 'Test', 1;
-- ================================================================================================
CREATE PROCEDURE [qan].[CreateOsatAttributeType]
(
	  @Id INT OUT
	, @Message VARCHAR(500) OUTPUT
	, @By VARCHAR(25)
	, @Name VARCHAR(50)
	, @NameDisplay VARCHAR(50)
	, @DataTypeId INT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionDescription VARCHAR (1000) = 'Create';
	DECLARE @ErrorsExist       BIT = 0;
	DECLARE @On                DATETIME2(7) = GETUTCDATE();
	DECLARE @Succeeded         BIT = 0;
	DECLARE @TempId            INT;

	SET @Id = NULL;
	SET @Message = NULL;

	-- begin standardization
	SET @Name = NULLIF(LOWER(RTRIM(LTRIM(@Name))), '');
	SET @NameDisplay = NULLIF(RTRIM(LTRIM(@NameDisplay)), '');
	-- end standardization

	SET @ActionDescription = @ActionDescription + '; Name = ' + ISNULL(@Name, 'null')
												+ '; NameDisplay = ' + ISNULL(@NameDisplay, 'null')
												+ '; DataTypeId = ' + ISNULL(CAST(@DataTypeId AS VARCHAR(20)), 'null');

	-- begin validation
	SELECT @TempId = MAX([Id]) FROM [ref].[OsatAttributeDataTypes] WITH (NOLOCK) WHERE [Id] = @DataTypeId;

	IF (@Name IS NULL)
	BEGIN
		SET @Message = 'Name is required';
		SET @ErrorsExist = 1;
	END;
	ELSE IF (@NameDisplay IS NULL)
	BEGIN
		SET @Message = 'Display Name is required';
		SET @ErrorsExist = 1;
	END;
	ELSE IF (@TempId IS NULL)
	BEGIN
		SET @Message = 'Data Type is invalid: ' + ISNULL(CAST(@DataTypeId AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END
	ELSE IF (EXISTS(SELECT 1 FROM [qan].[OsatAttributeTypes] WITH (NOLOCK) WHERE [Name] = @Name))
	BEGIN
		SET @Message = 'Name already in use';
		SET @ErrorsExist = 1;
	END
	ELSE IF (EXISTS(SELECT 1 FROM [qan].[OsatAttributeTypes] WITH (NOLOCK) WHERE [NameDisplay] = @NameDisplay))
	BEGIN
		SET @Message = 'Display Name already in use';
		SET @ErrorsExist = 1;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		INSERT INTO [qan].[OsatAttributeTypes]
		(
			  [Name]
			, [NameDisplay]
			, [DataTypeId]
			, [CreatedBy]
			, [CreatedOn]
			, [UpdatedBy]
			, [UpdatedOn]
		)
		VALUES
		(
			  @Name
			, @NameDisplay
			, @DataTypeId
			, @By
			, @On
			, @By
			, @On
		);

		SELECT @Id = SCOPE_IDENTITY();

		SET @Succeeded = 1;
	END;

	EXEC [qan].[CreateUserAction] NULL, @By, @ActionDescription, 'OSAT', 'Create', 'OsatAttributeType', @Id, NULL, @Succeeded, @Message;

END
