-- =========================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 17:10:27.030
-- Description  : Approves an mm recipe
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateMMRecipeApproved] NULL, @Message OUTPUT, NULL, 'bricschx', 0, 0, 'Test comment';
--                PRINT @Message; -- should print: 'Invalid mm recipe: 0'
-- =========================================================================================================================
CREATE PROCEDURE [qan].[UpdateMMRecipeApproved]
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
	DECLARE @ActionType                     VARCHAR(100) = 'Review Approve';
	DECLARE @ActionDescription              VARCHAR (1000) = @ActionType + '; SnapshotReviewerId = ' + CAST(@SnapshotReviewerId AS VARCHAR(20));
	DECLARE @AssociatedEntityId             BIGINT;
	DECLARE @AssociatedEntityType           VARCHAR(100);
	DECLARE @Count                          INT;
	DECLARE @CountEmails                    INT = 0;
	DECLARE @CurrentStatusId                INT;
	DECLARE @ErrorsExist                    BIT = 0;
	DECLARE @EmailTemplateIdAction          INT;
	DECLARE @EmailTemplateNameAction        VARCHAR(50) = 'ReviewAction';
	DECLARE @EmailTemplateIdApprove         INT;
	DECLARE @EmailTemplateNameApprove       VARCHAR(50) = 'ReviewApprove';
	DECLARE @EmailTemplateIdComplete        INT;
	DECLARE @EmailTemplateNameComplete      VARCHAR(50) = 'ReviewComplete';
	DECLARE @IsLastApproval                 BIT = 0;
	DECLARE @PCode                          VARCHAR(10);
	DECLARE @ReviewerId                     INT;
	DECLARE @ReviewGroupId                  INT;
	DECLARE @ReviewStageId                  INT;
	DECLARE @ReviewStageIdBefore            INT;
	DECLARE @ReviewStageIdAfter             INT;
	DECLARE @ReviewStageDisplayNameAfter    VARCHAR(100);
	DECLARE @SnapshotReviewStageIdAfter     BIGINT;
	DECLARE @SnapshotReviewStageIdBefore    BIGINT;
	DECLARE @VersionSubmittedBy             VARCHAR(25);
	DECLARE @VersionDescription             VARCHAR(500);

	SET @Succeeded = 0;
	SET @Message = NULL;
	SET @EmailBatchId = NULL;

	SELECT
		  @Count                         = COUNT(*)
		, @CurrentStatusId               = MAX([StatusId])
		, @VersionSubmittedBy            = MAX([SubmittedBy])
		, @PCode                         = MAX([PCode])
		, @VersionDescription            = MAX([PCode]) + '; ' + 'Version ' + CAST(MAX([Version]) AS VARCHAR(20))
	FROM [qan].[MMRecipes] WITH (NOLOCK) WHERE [Id] = @Id;

	SET @SnapshotReviewStageIdBefore = [qan].[FGetMMRecipeReviewCurrentSnapshotStageId](@Id);
	SELECT @ReviewStageIdBefore = MIN([ReviewStageId]) FROM [qan].[MMRecipeReviewStages] WITH (NOLOCK) WHERE [Id] = @SnapshotReviewStageIdBefore;

	SELECT @EmailTemplateIdApprove = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameApprove;
	SELECT @EmailTemplateIdAction = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameAction;
	SELECT @EmailTemplateIdComplete = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameComplete;

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
		SET @Message = 'Approve is not allowed for the current status';
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
		END
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
				, 1
				, @Comment
			);
			SET @AssociatedEntityId = @@IDENTITY;
			SET @AssociatedEntityType = 'MMRecipeReviewDecision';

			SET @SnapshotReviewStageIdAfter = [qan].[FGetMMRecipeReviewCurrentSnapshotStageId](@Id);

			IF (@SnapshotReviewStageIdAfter IS NULL) SET @IsLastApproval = 1;

			IF (@IsLastApproval = 1)
			BEGIN
				-- unset the IsPOR field for any that match the pcode
				UPDATE [qan].[MMRecipes] SET [IsPOR] = 0, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [IsPOR] = 1 AND [PCode] = @PCode;

				UPDATE [qan].[MMRecipes] SET [IsPOR] = 1, [StatusId] = 6, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id; -- StatusId 6 = Complete
			END
			ELSE If (@CurrentStatusId = 3) -- Submitted
			BEGIN
				UPDATE [qan].[MMRecipes] SET [StatusId] = 5, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id; -- StatusId 5 = In Review
			END;

			SELECT @EmailBatchId = ISNULL(MAX([BatchId]), 0) + 1 FROM [qan].[MMRecipeReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id;

			IF (@IsLastApproval = 1)
			BEGIN
				-- review complete; create PRQ email
				IF (@EmailTemplateIdComplete IS NOT NULL AND @VersionSubmittedBy IS NOT NULL)
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
						, @EmailTemplateIdComplete
						, @EmailTemplateNameComplete
						, [Email]
						, [Name]
						, @VersionDescription
						, GETUTCDATE()
					FROM [qan].[Users] WITH (NOLOCK) WHERE [IdSid] = @VersionSubmittedBy;
					SET @CountEmails = @CountEmails + @@ROWCOUNT;
				END;
			END
			ELSE
			BEGIN
				-- review still in progress; create approve and action emails
				SELECT @ReviewStageIdAfter = MIN([ReviewStageId]), @ReviewStageDisplayNameAfter = MIN([DisplayName]) FROM [qan].[MMRecipeReviewStages] WITH (NOLOCK) WHERE [Id] = @SnapshotReviewStageIdAfter;

				IF (@EmailTemplateIdApprove IS NOT NULL AND @VersionSubmittedBy IS NOT NULL)
				BEGIN
					INSERT INTO [qan].[MMRecipeReviewEmails]
					(
						  [VersionId]
						, [BatchId]
						, [SnapshotReviewStageId]
						, [ReviewStageId]
						, [EmailTemplateId]
						, [EmailTemplateName]
						, [To]
						, [RecipientName]
						, [VersionDescription]
						, [ReviewAtDescription]
						, [SentOn]
					)
					SELECT TOP 1
						  @Id
						, @EmailBatchId
						, @SnapshotReviewStageIdAfter
						, @ReviewStageIdAfter
						, @EmailTemplateIdApprove
						, @EmailTemplateNameApprove
						, [Email]
						, [Name]
						, @VersionDescription
						, @ReviewStageDisplayNameAfter
						, GETUTCDATE()
					FROM [qan].[Users] WITH (NOLOCK) WHERE [IdSid] = @VersionSubmittedBy;
					SET @CountEmails = @CountEmails + @@ROWCOUNT;
				END;

				IF (@EmailTemplateIdAction IS NOT NULL AND @SnapshotReviewStageIdBefore <> @SnapshotReviewStageIdAfter) -- emails already created for this stage if still on same snapshot stage id
				BEGIN
					INSERT INTO [qan].[MMRecipeReviewEmails]
					(
						  [VersionId]
						, [BatchId]
						, [SnapshotReviewStageId]
						, [ReviewStageId]
						, [EmailTemplateId]
						, [EmailTemplateName]
						, [To]
						, [RecipientName]
						, [VersionDescription]
						, [ReviewAtDescription]
						, [SentOn]
					)
					SELECT DISTINCT -- distinct important so users in multiple groups for the same stage do not get multiple emails
						  @Id
						, @EmailBatchId
						, @SnapshotReviewStageIdAfter
						, @ReviewStageIdAfter
						, @EmailTemplateIdAction
						, @EmailTemplateNameAction
						, [Email]
						, [Name]
						, @VersionDescription
						, @ReviewStageDisplayNameAfter
						, GETUTCDATE()
					FROM [qan].[MMRecipeReviewers] WHERE [VersionId] = @Id AND [ReviewStageId] = @ReviewStageIdAfter;
					SET @CountEmails = @CountEmails + @@ROWCOUNT;
				END;
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
