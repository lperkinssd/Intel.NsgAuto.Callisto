-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 17:38:01.867
-- Description  : Cancels an auto checker build criteria
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateAcBuildCriteriaCanceled] NULL, @Message OUTPUT, NULL, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid build criteria: 0'
-- =====================================================================================================
CREATE PROCEDURE [qan].[UpdateAcBuildCriteriaCanceled]
(
	  @Succeeded    BIT                  OUTPUT
	, @Message      VARCHAR(500)         OUTPUT
	, @EmailBatchId INT                  OUTPUT
	, @UserId       VARCHAR(25)
	, @Id           BIGINT
	, @Override     BIT          = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionType         VARCHAR(100) = 'Review Cancel';
	DECLARE @ActionDescription  VARCHAR (1000) = @ActionType;
	DECLARE @Count              INT;
	DECLARE @CountEmails        INT = 0;
	DECLARE @CreatedBy          VARCHAR(25);
	DECLARE @CurrentStatusId    INT;
	DECLARE @ErrorsExist        BIT = 0;
	DECLARE @EmailTemplateId    INT;
	DECLARE @EmailTemplateName  VARCHAR(50) = 'ReviewCancel';
	DECLARE @NewStatusId        INT = 2; -- Canceled
	DECLARE @VersionDescription VARCHAR(500);

	SET @Succeeded = 0;
	SET @Message = NULL;
	SET @EmailBatchId = NULL;

	SELECT
		  @Count              = COUNT(*)
		, @CurrentStatusId    = MAX([StatusId])
		, @CreatedBy          = MAX([CreatedBy])
		, @VersionDescription = MAX([BuildCombinationName]) + ' [Version ' + CAST(MAX([Version]) AS VARCHAR(20)) + ']'
	FROM [qan].[FAcBuildCriterias](@Id, @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

	SELECT @EmailTemplateId = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateName;

	-- standardization
	IF (@Override IS NULL) SET @Override = 0;

	-- begin validation
	IF (@Count = 0)
	BEGIN
		SET @Message = 'Invalid build criteria: ' + ISNULL(CAST(@Id AS VARCHAR(20)), '');
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
		-- for now, only the user who created the build criteria may cancel it
		ELSE IF (@UserId IS NULL OR @UserId <> @CreatedBy)
		BEGIN
			SET @Message = 'Unauthorized';
			SET @ErrorsExist = 1;
		END;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION
			UPDATE [qan].[AcBuildCriterias] SET [StatusId] = @NewStatusId, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id;

			SELECT @EmailBatchId = ISNULL(MAX([BatchId]), 0) + 1 FROM [qan].[AcBuildCriteriaReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id;
			IF (@EmailTemplateId IS NOT NULL)
			BEGIN
				INSERT INTO [qan].[AcBuildCriteriaReviewEmails]
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

			EXEC [qan].[CreateAcBuildCriteriaReviewChangeHistory] NULL, @Id, @ActionDescription, @UserId;
		COMMIT;
		SET @Succeeded = 1;
	END;

	IF (@Override = 1) SET @ActionDescription = @ActionDescription + '; Override = 1';
	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'Auto Checker', @ActionType, 'AcBuildCriteria', @Id, NULL, @Succeeded, @Message;

END
