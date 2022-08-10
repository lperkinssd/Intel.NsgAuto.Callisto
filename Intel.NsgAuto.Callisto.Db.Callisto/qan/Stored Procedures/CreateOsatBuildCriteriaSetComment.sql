-- ==================================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-01 15:24:14.797
-- Description  : Creates a new osat build criteria set comment. After execution, if the output parameter @Id is null, then the comment was not
--                created and @Message contains the reason. Do not alter and return result sets from this stored procedure. If you want result sets
--                to be returned, use composition (i.e. create a new stored procedure and call this).
-- Example      : DECLARE @Id BIGINT;
--                DECLARE @Message VARCHAR(500);
--                DECLARE @BuildCriteriaSetId BIGINT = 0;
--                EXEC [qan].[CreateOsatBuildCriteriaSetComment] @Id OUTPUT, @Message OUTPUT, 'bricschx', @BuildCriteriaSetId, 'test comment';
--                PRINT @Id;
--                PRINT @Message;
--                -- should print Invalid build criteria set: 0;
-- ==================================================================================================================================================
CREATE PROCEDURE [qan].[CreateOsatBuildCriteriaSetComment]
(
	  @Id                    BIGINT       OUTPUT
	, @Message               VARCHAR(500) OUTPUT
	, @UserId                VARCHAR(25)
	, @BuildCriteriaSetId    BIGINT
	, @Text                  VARCHAR(1000)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionDescription          VARCHAR (1000) = 'Create';
	DECLARE @BuildCriteriaSetIdValid    BIGINT;
	DECLARE @TextMaxCharacters          INT = 1000;
	DECLARE @ErrorsExist                BIT = 0;
	DECLARE @Succeeded                  BIT = 0;

	SET @Id = NULL;
	SET @Message = NULL;

	-- standardization
	SET @Text = NULLIF(RTRIM(LTRIM(@Text)), '');

	-- begin validation
	SELECT @BuildCriteriaSetIdValid = MAX([Id]) FROM [qan].[OsatBuildCriteriaSets] WITH (NOLOCK) WHERE [Id] = @BuildCriteriaSetId;

	IF (@BuildCriteriaSetIdValid IS NULL)
	BEGIN
		SET @Message = 'Invalid build criteria set: ' + ISNULL(CAST(@BuildCriteriaSetId AS VARCHAR(20)), '');
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

			INSERT INTO [qan].[OsatBuildCriteriaSetComments]
			(
				  [BuildCriteriaSetId]
				, [Text]
				, [CreatedBy]
				, [UpdatedBy]
			)
			VALUES
			(
				  @BuildCriteriaSetId
				, @Text
				, @UserId
				, @UserId
			);

			SELECT @Id = SCOPE_IDENTITY();

		COMMIT;

		SET @Succeeded = 1;
	END;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', 'Create', 'OsatBuildCriteriaSetComment', @Id, NULL, @Succeeded, @Message, 'OsatBuildCriteriaSet', @BuildCriteriaSetId;

END
