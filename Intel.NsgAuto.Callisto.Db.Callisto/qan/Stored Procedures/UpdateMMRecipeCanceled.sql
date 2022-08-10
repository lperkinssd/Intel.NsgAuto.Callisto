-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-14 11:50:05.800
-- Description  : Cancels an mm recipe
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateMMRecipeCanceled] NULL, @Message OUTPUT, NULL, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid mm recipe: 0'
-- =====================================================================================================
CREATE PROCEDURE [qan].[UpdateMMRecipeCanceled]
(
	  @Succeeded    BIT          OUTPUT
	, @Message      VARCHAR(500) OUTPUT
	, @EmailBatchId INT          OUTPUT
	, @UserId       VARCHAR(25)
	, @Id           BIGINT
	, @Override     BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionType          VARCHAR(100) = 'Review Cancel';
	DECLARE @ActionDescription   VARCHAR (1000) = @ActionType;
	DECLARE @Count               INT;
	DECLARE @CountEmails         INT = 0;
	DECLARE @CreatedBy           VARCHAR(25);
	DECLARE @CurrentStatusId     INT;
	DECLARE @ErrorsExist         BIT = 0;
	DECLARE @EmailTemplateId     INT;
	DECLARE @EmailTemplateName   VARCHAR(50) = 'ReviewCancel';
	DECLARE @NewStatusId         INT = 2; -- Canceled
	DECLARE @VersionDescription  VARCHAR(500);

	SET @Succeeded = 0;
	SET @Message = NULL;
	SET @EmailBatchId = NULL;

	SELECT
		  @Count               = COUNT(*)
		, @CurrentStatusId     = MAX([StatusId])
		, @CreatedBy           = MAX([CreatedBy])
		, @VersionDescription  = MAX([PCode]) + '; ' + 'Version ' + CAST(MAX([Version]) AS VARCHAR(20))
	FROM [qan].[MMRecipes] WITH (NOLOCK) WHERE [Id] = @Id;

	SELECT @EmailTemplateId = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateName;

	-- standardization
	IF (@Override IS NULL) SET @Override = 0;

	-- begin validation
	IF (@Count = 0)
	BEGIN
		SET @Message = 'Invalid mm recipe: ' + ISNULL(CAST(@Id AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END;
	-- if @Override = 1 skip the validation inside the BEGIN/END block
	ELSE IF (@Override = 0)
	BEGIN
		IF (@CurrentStatusId IS NULL OR @CurrentStatusId <> 1) -- 1 = Draft
		BEGIN
			SET @Message = 'Cancel is not allowed for the current status';
			SET @ErrorsExist = 1;
		END;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION
			UPDATE [qan].[MMRecipes] SET [StatusId] = @NewStatusId, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id;

			SELECT @EmailBatchId = ISNULL(MAX([BatchId]), 0) + 1 FROM [qan].[MMRecipeReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id;
			IF (@EmailTemplateId IS NOT NULL)
			BEGIN
				INSERT INTO [qan].[MMRecipeReviewEmails]
				(
					  [VersionId]
					, [BatchId]
					, [EmailTemplateId]
					, [EmailTemplateName]
					, [To]
					, [RecipientName]
					, [VersionDescription]
					, [SentOn]
				)
				SELECT TOP 1
					  @Id
					, @EmailBatchId
					, @EmailTemplateId
					, @EmailTemplateName
					, [Email]
					, [Name]
					, @VersionDescription
					, GETUTCDATE()
				FROM [qan].[Users] WITH (NOLOCK) WHERE [IdSid] = @UserId;
				SET @CountEmails = @CountEmails + @@ROWCOUNT;
			END;

			IF (@CountEmails = 0) SET @EmailBatchId = NULL; -- make sure it is set to null if no email records were inserted

			SET @ActionDescription = @ActionDescription + '; Emails: ' + CAST(@CountEmails AS VARCHAR(20));

			EXEC [qan].[CreateMMRecipeReviewChangeHistory] NULL, @Id, @ActionDescription, @UserId;
		COMMIT;
		SET @Succeeded = 1;
	END;

	IF (@Override = 1) SET @ActionDescription = @ActionDescription + '; Override = 1';
	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'MM Recipe', @ActionType, 'MMRecipe', @Id, NULL, @Succeeded, @Message;

END
