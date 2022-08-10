-- =========================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 17:44:05.030
-- Description  : Rejects an mm recipe
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateMMRecipeRejected] NULL, @Message OUTPUT, NULL, 'bricschx', 0, 0, 'Test comment';
--                PRINT @Message; -- should print: 'Invalid mm recipe: 0'
-- =========================================================================================================================
CREATE PROCEDURE [qan].[UpdateMMRecipeRejected]
(
	  @Succeeded           BIT          OUTPUT
	, @Message             VARCHAR(500) OUTPUT
	, @EmailBatchId        INT          OUTPUT
	, @UserId              VARCHAR(25)
	, @Id                  BIGINT
	, @SnapshotReviewerId  BIGINT
	, @Comment             VARCHAR(1000) = NULL
	, @Override            BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionType                       VARCHAR(100) = 'Review Reject';
	DECLARE @ActionDescription                VARCHAR (1000) = @ActionType + '; SnapshotReviewerId = ' + CAST(@SnapshotReviewerId AS VARCHAR(20));
	DECLARE @AssociatedEntityId               BIGINT;
	DECLARE @AssociatedEntityType             VARCHAR(100);
	DECLARE @Count                            INT;
	DECLARE @CountEmails                      INT = 0;
	DECLARE @CurrentStatusId                  INT;
	DECLARE @EmailTemplateIdReject            INT;
	DECLARE @EmailTemplateNameReject          VARCHAR(50) = 'ReviewReject';
	DECLARE @EmailTemplateIdRejectReviewer    INT;
	DECLARE @EmailTemplateNameRejectReviewer  VARCHAR(50) = 'ReviewRejectReviewer';
	DECLARE @ErrorsExist                      BIT = 0;
	DECLARE @NewStatusId                      INT = 4; -- Rejected
	DECLARE @ReviewerId                       INT;
	DECLARE @ReviewGroupId                    INT;
	DECLARE @ReviewStageId                    INT;
	DECLARE @ReviewStageIdBefore              INT;
	DECLARE @SnapshotReviewStageIdBefore      BIGINT;
	DECLARE @VersionSubmittedBy               VARCHAR(25);
	DECLARE @VersionDescription               VARCHAR(500);

	SET @Succeeded = 0;
	SET @Message = NULL;
	SET @EmailBatchId = NULL;

	SELECT
		  @Count               = COUNT(*)
		, @CurrentStatusId     = MAX([StatusId])
		, @VersionSubmittedBy  = MAX([SubmittedBy])
		, @VersionDescription  = MAX([PCode]) + '; ' + 'Version ' + CAST(MAX([Version]) AS VARCHAR(20))
	FROM [qan].[MMRecipes] WITH (NOLOCK) WHERE [Id] = @Id;

	SET @SnapshotReviewStageIdBefore = [qan].[FGetMMRecipeReviewCurrentSnapshotStageId](@Id);
	SELECT @ReviewStageIdBefore = MIN([ReviewStageId]) FROM [qan].[MMRecipeReviewStages] WITH (NOLOCK) WHERE [Id] = @SnapshotReviewStageIdBefore;

	SELECT @EmailTemplateIdReject = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameReject;
	SELECT @EmailTemplateIdRejectReviewer = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameRejectReviewer;

	-- standardization
	SET @Comment = NULLIF(RTRIM(LTRIM(@Comment)), '');
	IF (@Override IS NULL) SET @Override = 0;

	-- begin validation
	IF (NOT @Count = 1)
	BEGIN
		SET @Message = 'Invalid mm recipe: ' + ISNULL(CAST(@Id AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END;
	ELSE IF (@Override = 0 AND (@CurrentStatusId IS NULL OR @CurrentStatusId NOT IN (3, 5))) -- ('Submitted', 'In Review')
	BEGIN
		SET @Message = 'Reject is not allowed for the current status';
		SET @ErrorsExist = 1;
	END;
	ELSE
	BEGIN
		DECLARE @VersionId BIGINT;
		DECLARE @Idsid     VARCHAR(50);

		SELECT
			  @Count = COUNT(*)
			, @VersionId = MAX([VersionId])
			, @ReviewStageId = MAX([ReviewStageId])
			, @ReviewGroupId = MAX([ReviewGroupId])
			, @ReviewerId = MAX([ReviewerId])
			, @Idsid = MAX([Idsid])
		FROM [qan].[MMRecipeReviewers] WHERE [Id] = @SnapshotReviewerId;

		IF (NOT @Count = 1)
		BEGIN
			SET @Message = 'Invalid snapshot reviewer id: ' + ISNULL(CAST(@SnapshotReviewerId AS VARCHAR(20)), '');
			SET @ErrorsExist = 1;
		END;
		ELSE
		BEGIN
			SET @ActionDescription = @ActionDescription + '; ReviewStageId = ' + CAST(@ReviewStageId AS VARCHAR(20))
														+ '; ReviewGroupId = ' + CAST(@ReviewGroupId AS VARCHAR(20))
														+ '; ReviewerId = ' + CAST(@ReviewerId AS VARCHAR(20));

			IF (@Id <> @VersionId OR @VersionId IS NULL)
			BEGIN
				SET @Message = 'Version id mismatch: ' + ISNULL(CAST(@Id AS VARCHAR(20)), '') + ' vs ' + ISNULL(CAST(@VersionId AS VARCHAR(20)), '');
				SET @ErrorsExist = 1;
			END
			ELSE IF (@Override = 0 AND (@UserId <> @Idsid OR @Idsid IS NULL))
			BEGIN
				SET @Message = 'User id mismatch: ' + @UserId + ' vs ' + @Idsid;
				SET @ErrorsExist = 1;
			END
			ELSE IF (@ReviewStageId IS NULL OR @ReviewStageIdBefore IS NULL OR @ReviewStageId <> @ReviewStageIdBefore)
			BEGIN
				SET @Message = 'Review stage id mismatch: ' + ISNULL(CAST(@ReviewStageIdBefore AS VARCHAR(20)), '') + ' vs ' + ISNULL(CAST(@ReviewStageId AS VARCHAR(20)), '');
				SET @ErrorsExist = 1;
			END;
		END;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION
			INSERT INTO [qan].[MMRecipeReviewDecisions]
			(
				  [SnapshotReviewerId]
				, [VersionId]
				, [ReviewStageId]
				, [ReviewGroupId]
				, [ReviewerId]
				, [IsApproved]
				, [Comment]
			)
			VALUES
			(
				  @SnapshotReviewerId
				, @Id
				, @ReviewStageId
				, @ReviewGroupId
				, @ReviewerId
				, 0 -- rejected = not approved
				, @Comment
			);
			SET @AssociatedEntityId = @@IDENTITY;
			SET @AssociatedEntityType = 'MMRecipeReviewDecision';

			UPDATE [qan].[MMRecipes] SET [StatusId] = @NewStatusId, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id;

			SELECT @EmailBatchId = ISNULL(MAX([BatchId]), 0) + 1 FROM [qan].[MMRecipeReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id;

			IF (@EmailTemplateIdReject IS NOT NULL AND @VersionSubmittedBy IS NOT NULL)
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
					, @EmailTemplateIdReject
					, @EmailTemplateNameReject
					, [Email]
					, [Name]
					, @VersionDescription
					, GETUTCDATE()
				FROM [qan].[Users] WITH (NOLOCK) WHERE [IdSid] = @VersionSubmittedBy;
				SET @CountEmails = @CountEmails + @@ROWCOUNT;
			END;

			IF (@EmailTemplateIdRejectReviewer IS NOT NULL)
			BEGIN
				-- only send emails to reviewers who have already been notified about review action on this version
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
				SELECT DISTINCT -- distinct important so users in multiple groups for the same stage do not get multiple emails
					  @Id
					, @EmailBatchId
					, @EmailTemplateIdRejectReviewer
					, @EmailTemplateNameRejectReviewer
					, [To]
					, [RecipientName]
					, @VersionDescription
					, GETUTCDATE()
				FROM [qan].[MMRecipeReviewEmails] WHERE [VersionId] = @Id AND [EmailTemplateName] = 'ReviewAction';
				SET @CountEmails = @CountEmails + @@ROWCOUNT;
			END;

			IF (@CountEmails = 0) SET @EmailBatchId = NULL; -- make sure it is set to null if no email records were inserted

			SET @ActionDescription = @ActionDescription + '; Emails: ' + CAST(@CountEmails AS VARCHAR(20));

			EXEC [qan].[CreateMMRecipeReviewChangeHistory] NULL, @Id, @ActionDescription, @UserId;
		COMMIT;
		SET @Succeeded = 1;
	END;

	IF (@Override = 1) SET @ActionDescription = @ActionDescription + '; Override = 1';
	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'MM Recipe', @ActionType, 'MMRecipe', @Id, NULL, @Succeeded, @Message, @AssociatedEntityType, @AssociatedEntityId;

END
