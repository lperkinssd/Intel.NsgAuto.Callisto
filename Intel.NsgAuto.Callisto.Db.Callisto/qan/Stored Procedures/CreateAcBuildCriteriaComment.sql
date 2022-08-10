-- ==================================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-01 15:22:28.113
-- Description  : Creates a new auto checker build criteria comment. After execution, if the output parameter @Id is null, then the comment was not
--                created and @Message contains the reason. Do not alter and return result sets from this stored procedure. If you want result sets
--                to be returned, create a new stored procedure and call this.
-- Example      : DECLARE @Id BIGINT;
--                DECLARE @Message VARCHAR(500);
--                DECLARE @BuildCriteriaId BIGINT = 0;
--                EXEC [qan].[CreateAcBuildCriteriaComment] @Id OUTPUT, @Message OUTPUT, 'bricschx', @BuildCriteriaId, 'test comment';
--                PRINT @Id;
--                PRINT @Message;
--                -- should print Invalid build criteria: 0;
-- ==================================================================================================================================================
CREATE PROCEDURE [qan].[CreateAcBuildCriteriaComment]
(
	  @Id                    BIGINT       OUTPUT
	, @Message               VARCHAR(500) OUTPUT
	, @UserId                VARCHAR(25)
	, @BuildCriteriaId       BIGINT
	, @Text                  VARCHAR(1000)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionDescription          VARCHAR (1000) = 'Create';
	DECLARE @BuildCriteriaIdValid       BIGINT;
	DECLARE @TextMaxCharacters          INT = 1000;
	DECLARE @ErrorsExist                BIT = 0;
	DECLARE @Succeeded                  BIT = 0;

	SET @Id = NULL;
	SET @Message = NULL;

	-- standardization
	SET @Text = NULLIF(RTRIM(LTRIM(@Text)), '');

	-- begin validation
	SELECT @BuildCriteriaIdValid = MAX([Id]) FROM [qan].[AcBuildCriterias] WITH (NOLOCK) WHERE [Id] = @BuildCriteriaId;

	IF (@BuildCriteriaIdValid IS NULL)
	BEGIN
		SET @Message = 'Invalid build criteria: ' + ISNULL(CAST(@BuildCriteriaId AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END
	ELSE IF (@Text IS NULL)
	BEGIN
		SET @Message = 'Text cannot be empty';
		SET @ErrorsExist = 1;
	END
	ELSE IF (LEN(@Text) > @TextMaxCharacters)
	BEGIN
		SET @Message = 'Text exceeds maximum allowed characters: ' + CAST(@TextMaxCharacters AS VARCHAR(20));
		SET @ErrorsExist = 1;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION

			INSERT INTO [qan].[AcBuildCriteriaComments]
			(
				  [BuildCriteriaId]
				, [Text]
				, [CreatedBy]
				, [UpdatedBy]
			)
			VALUES
			(
				  @BuildCriteriaId
				, @Text
				, @UserId
				, @UserId
			);

			SELECT @Id = SCOPE_IDENTITY();

		COMMIT;

		SET @Succeeded = 1;
	END;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'Auto Checker', 'Create', 'AcBuildCriteriaComment', @Id, NULL, @Succeeded, @Message, 'AcBuildCriteria', @BuildCriteriaId;

END
