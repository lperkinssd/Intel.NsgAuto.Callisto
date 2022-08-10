-- ==============================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-04 14:18:36.937
-- Description  : Rejects an osat build criteria set
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatBuildCriteriaSetRejected] NULL, @Message OUTPUT, NULL, 'bricschx', 0, 0, 'Test comment';
--                PRINT @Message; -- should print: 'Invalid build criteria set: 0'
-- ==============================================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatBuildCriteriaSetRejected]
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
	DECLARE @EmailAddresses                   [qan].[IStrings];
	DECLARE @EmailRecipientName               VARCHAR(255);
	DECLARE @EmailTemplateIdReject            INT;
	DECLARE @EmailTemplateNameReject          VARCHAR(50) = 'ReviewReject';
	DECLARE @EmailTemplateIdRejectReviewer    INT;
	DECLARE @EmailTemplateNameRejectReviewer  VARCHAR(50) = 'ReviewRejectReviewer';
	DECLARE @EmailTo                          VARCHAR(2000);
	DECLARE @ErrorsExist                      BIT = 0;
	DECLARE @NewStatusId                      INT = 4; -- Rejected
	DECLARE @ReviewAtDescription              VARCHAR(255);
	DECLARE @ReviewerId                       INT;
	DECLARE @ReviewGroupId                    INT;
	DECLARE @ReviewStageId                    INT;
	DECLARE @ReviewStageIdBefore              INT;
	DECLARE @SnapshotReviewGroupId            BIGINT;
	DECLARE @SnapshotReviewStageIdBefore      BIGINT;
	DECLARE @VersionCreatedBy                 VARCHAR(25);
	DECLARE @VersionDescription               VARCHAR(500);

	SET @Succeeded = 0;
	SET @Message = NULL;
	SET @EmailBatchId = NULL;

	SELECT
		  @Count              = COUNT(*)
		, @CurrentStatusId    = MAX([StatusId])
		, @VersionCreatedBy   = MAX([CreatedBy])
		, @VersionDescription = MAX([BuildCombinationIntelProdName]) + ' ' + MAX([BuildCombinationMaterialMasterField]) + ' ' + MAX([BuildCombinationAssyUpi]) + ' [Version ' + CAST(MAX([Version]) AS VARCHAR(20)) + ']'
	FROM [qan].[FOsatBuildCriteriaSets](@Id, @UserId, NULL, NULL, NULL, NULL, NULL);

	SET @SnapshotReviewStageIdBefore = [qan].[FGetOsatBuildCriteriaSetReviewCurrentSnapshotStageId](@Id);
	SELECT @ReviewStageIdBefore = MIN([ReviewStageId]) FROM [qan].[OsatBuildCriteriaSetReviewStages] WITH (NOLOCK) WHERE [Id] = @SnapshotReviewStageIdBefore;

	SELECT @EmailTemplateIdReject = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameReject;
	SELECT @EmailTemplateIdRejectReviewer = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameRejectReviewer;

	-- standardization
	SET @Comment = NULLIF(RTRIM(LTRIM(@Comment)), '');
	IF (@Override IS NULL) SET @Override = 0;

	-- begin validation
	IF (NOT @Count = 1)
	BEGIN
		SET @Message = 'Invalid build criteria set: ' + ISNULL(CAST(@Id AS VARCHAR(20)), '');
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
		FROM [qan].[OsatBuildCriteriaSetReviewers] WHERE [Id] = @SnapshotReviewerId;

		SELECT @SnapshotReviewGroupId = MAX([Id]) FROM [qan].[OsatBuildCriteriaSetReviewGroups] WITH (NOLOCK) WHERE [VersionId] = @Id AND [ReviewGroupId] = @ReviewGroupId;

		SELECT @ReviewAtDescription = ISNULL(MIN(S.[DisplayName]), '') + ' > ' + ISNULL(MIN(G.[DisplayName]), '')
		FROM [qan].[OsatBuildCriteriaSetReviewGroups] AS G WITH (NOLOCK)
		INNER JOIN [qan].[OsatBuildCriteriaSetReviewStages] AS S WITH (NOLOCK) ON (S.[VersionId] = G.[VersionId] AND S.[ReviewStageId] = G.[ReviewStageId])
		WHERE G.[Id] = @SnapshotReviewGroupId;

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
			INSERT INTO [qan].[OsatBuildCriteriaSetReviewDecisions]
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
			SET @AssociatedEntityType = 'OsatBuildCriteriaSetReviewDecision';

			UPDATE [qan].[OsatBuildCriteriaSets] SET [StatusId] = @NewStatusId, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id;

			SELECT @EmailBatchId = ISNULL(MAX([BatchId]), 0) + 1 FROM [qan].[OsatBuildCriteriaSetReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id;

			IF (@EmailTemplateIdReject IS NOT NULL)
			BEGIN
				SELECT @EmailRecipientName = MAX([Name]) FROM [qan].[Users] WITH (NOLOCK) WHERE [IdSid] = @VersionCreatedBy;

				DELETE FROM @EmailAddresses;
				INSERT INTO @EmailAddresses
				SELECT [Email] FROM
				(
					SELECT [Email] FROM [qan].[Users] WITH (NOLOCK) WHERE [IdSid] = @VersionCreatedBy
					UNION
					SELECT DISTINCT [Email] FROM [qan].[OsatBuildCriteriaSetReviewers] WITH (NOLOCK) WHERE [VersionId] = @Id AND [ReviewStageId] IN (SELECT [ReviewStageId] FROM [qan].[OsatBuildCriteriaSetReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id AND [EmailTemplateName] = 'ReviewAction')
				) AS T;
				SET @EmailTo = [qan].ToDelimitedString(@EmailAddresses, ';', '');

				INSERT INTO [qan].[OsatBuildCriteriaSetReviewEmails]
				(
					  [VersionId]
					, [BatchId]
					, [SnapshotReviewStageId]
					, [ReviewStageId]
					, [SnapshotReviewGroupId]
					, [ReviewGroupId]
					, [EmailTemplateId]
					, [EmailTemplateName]
					, [To]
					, [RecipientName]
					, [VersionDescription]
					, [ReviewAtDescription]
					, [SentOn]
				)
				VALUES
				(
					  @Id                             -- [VersionId]
					, @EmailBatchId                   -- [BatchId]
					, @SnapshotReviewStageIdBefore    -- [SnapshotReviewStageId]
					, @ReviewStageId                  -- [ReviewStageId]
					, @SnapshotReviewGroupId          -- [SnapshotReviewGroupId]
					, @ReviewGroupId                  -- [ReviewGroupId]
					, @EmailTemplateIdReject          -- [EmailTemplateId]
					, @EmailTemplateNameReject        -- [EmailTemplateName]
					, @EmailTo                        -- [To]
					, @EmailRecipientName             -- [RecipientName]
					, @VersionDescription             -- [VersionDescription]
					, @ReviewAtDescription            -- [ReviewAtDescription]
					, GETUTCDATE()                    -- [SentOn]
				);
				SET @CountEmails = @CountEmails + @@ROWCOUNT;
			END;

			IF (@CountEmails = 0) SET @EmailBatchId = NULL; -- make sure it is set to null if no email records were inserted

			SET @ActionDescription = @ActionDescription + '; Emails: ' + CAST(@CountEmails AS VARCHAR(20));

			EXEC [qan].[CreateOsatBuildCriteriaSetReviewChangeHistory] NULL, @Id, @ActionDescription, @UserId;
		COMMIT;
		SET @Succeeded = 1;
	END;

	IF (@Override = 1) SET @ActionDescription = @ActionDescription + '; Override = 1';
	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', @ActionType, 'OsatBuildCriteriaSet', @Id, NULL, @Succeeded, @Message, @AssociatedEntityType, @AssociatedEntityId;

END
