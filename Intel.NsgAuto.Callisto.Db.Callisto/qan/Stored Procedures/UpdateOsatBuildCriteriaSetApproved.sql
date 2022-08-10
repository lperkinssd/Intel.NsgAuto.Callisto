-- ==============================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-04 14:29:57.917
-- Description  : Approves an osat build criteria set
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatBuildCriteriaSetApproved] NULL, @Message OUTPUT, NULL, 'bricschx', 0, 0, 'Test comment';
--                PRINT @Message; -- should print: 'Invalid build criteria set: 0'
-- ==============================================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatBuildCriteriaSetApproved]
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
	DECLARE @BuildCombinationId             INT;
	DECLARE @Count                          INT;
	DECLARE @CountGroupsNoDecision          INT;
	DECLARE @CountEmails                    INT = 0;
	DECLARE @CurrentStatusId                INT;
	DECLARE @ErrorsExist                    BIT = 0;
	DECLARE @EmailAddresses                 [qan].[IStrings];
	DECLARE @EmailTemplateIdAction          INT;
	DECLARE @EmailTemplateNameAction        VARCHAR(50) = 'ReviewAction';
	DECLARE @EmailTemplateIdApprove         INT;
	DECLARE @EmailTemplateNameApprove       VARCHAR(50) = 'ReviewApprove';
	DECLARE @EmailTemplateIdComplete        INT;
	DECLARE @EmailTemplateNameComplete      VARCHAR(50) = 'ReviewComplete';
	DECLARE @EmailTo                        VARCHAR(2000);
	DECLARE @IsLastApproval                 BIT = 0;
	DECLARE @ReviewAtDescription            VARCHAR(255);
	DECLARE @ReviewerId                     INT;
	DECLARE @ReviewGroupId                  INT;
	DECLARE @ReviewGroupIdNoDecision        INT;
	DECLARE @ReviewStageId                  INT;
	DECLARE @ReviewStageIdBefore            INT;
	DECLARE @ReviewStageIdAfter             INT;
	DECLARE @ReviewStageDisplayNameAfter    VARCHAR(100);
	DECLARE @SnapshotReviewGroupId          BIGINT;
	DECLARE @SnapshotReviewStageIdAfter     BIGINT;
	DECLARE @SnapshotReviewStageIdBefore    BIGINT;
	DECLARE @VersionCreatedBy               VARCHAR(25);
	DECLARE @VersionCreatedByEmail          VARCHAR(255);
	DECLARE @VersionDescription             VARCHAR(500);

	SET @Succeeded = 0;
	SET @Message = NULL;
	SET @EmailBatchId = NULL;

	SELECT
		  @Count                         = COUNT(*)
		, @CurrentStatusId               = MAX([StatusId])
		, @BuildCombinationId            = MAX([BuildCombinationId])
		, @VersionCreatedBy              = MAX([CreatedBy])
		, @VersionDescription = MAX([BuildCombinationIntelProdName]) + ' ' + MAX([BuildCombinationMaterialMasterField]) + ' ' + MAX([BuildCombinationAssyUpi]) + ' [Version ' + CAST(MAX([Version]) AS VARCHAR(20)) + ']'
	FROM [qan].[FOsatBuildCriteriaSets](@Id, @UserId, NULL, NULL, NULL, NULL, NULL);

	SET @SnapshotReviewStageIdBefore = [qan].[FGetOsatBuildCriteriaSetReviewCurrentSnapshotStageId](@Id);
	SELECT @ReviewStageIdBefore = MIN([ReviewStageId]) FROM [qan].[OsatBuildCriteriaSetReviewStages] WITH (NOLOCK) WHERE [Id] = @SnapshotReviewStageIdBefore;

	SELECT @CountGroupsNoDecision = COUNT(*), @ReviewGroupIdNoDecision = MAX([ReviewGroupId]) FROM [qan].[FOsatBuildCriteriaSetReviewGroupsNoDecision](@Id);

	SELECT @EmailTemplateIdApprove = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameApprove;
	SELECT @EmailTemplateIdAction = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameAction;
	SELECT @EmailTemplateIdComplete = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameComplete;

	SELECT @VersionCreatedByEmail = MIN([Email]) FROM [qan].[Users] WITH (NOLOCK) WHERE [IdSid] = @VersionCreatedBy;

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

	IF (@ErrorsExist = 0 AND @CountGroupsNoDecision = 1 AND @ReviewGroupIdNoDecision = @ReviewGroupId)
	BEGIN
		SET @IsLastApproval = 1;
	END;

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION

			IF (@IsLastApproval = 1)
			BEGIN
				-- unset the IsPOR field for any that match the build combination id
				UPDATE [qan].[OsatBuildCriteriaSets] SET [IsPOR] = 0, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [IsPOR] = 1 AND [BuildCombinationId] = @BuildCombinationId;

				UPDATE [qan].[OsatBuildCriteriaSets] SET [IsPOR] = 1, [StatusId] = 6, [EffectiveOn] = GETUTCDATE(), [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id; -- StatusId 6 = Complete


			END -- is last approval
			ELSE If (@CurrentStatusId = 3) -- Submitted
			BEGIN
				UPDATE [qan].[OsatBuildCriteriaSets] SET [StatusId] = 5, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id; -- StatusId 5 = In Review
			END;

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
				, 1
				, @Comment
			);
			SET @AssociatedEntityId = @@IDENTITY;
			SET @AssociatedEntityType = 'OsatBuildCriteriaSetReviewDecision';

			SET @SnapshotReviewStageIdAfter = [qan].[FGetOsatBuildCriteriaSetReviewCurrentSnapshotStageId](@Id);

			SELECT @EmailBatchId = ISNULL(MAX([BatchId]), 0) + 1 FROM [qan].[OsatBuildCriteriaSetReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id;

			IF (@EmailTemplateIdApprove IS NOT NULL)
			BEGIN
				SET @EmailTo = [qan].[OsatBuildCriteriaSetReviewerEmailsAsDelimitedString](';', @Id, NULL, @ReviewGroupId);

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
					, [Cc]
					, [VersionDescription]
					, [ReviewAtDescription]
					, [SentOn]
				)
				VALUES
				(
					  @Id                              -- [VersionId]
					, @EmailBatchId                    -- [BatchId]
					, @SnapshotReviewStageIdBefore     -- [SnapshotReviewStageId]
					, @ReviewStageIdBefore             -- [ReviewStageId]
					, @SnapshotReviewGroupId           -- [SnapshotReviewGroupId]
					, @ReviewGroupId                   -- [ReviewGroupId]
					, @EmailTemplateIdApprove          -- [EmailTemplateId]
					, @EmailTemplateNameApprove        -- [EmailTemplateName]
					, @EmailTo                         -- [To]
					, @VersionCreatedByEmail           -- [Cc]
					, @VersionDescription              -- [VersionDescription]
					, @ReviewAtDescription             -- [ReviewAtDescription]
					, GETUTCDATE()                     -- [SentOn]
				);
				SET @CountEmails = @CountEmails + @@ROWCOUNT;
			END;

			IF (@IsLastApproval = 1)
			BEGIN
				DELETE FROM @EmailAddresses;
				INSERT INTO @EmailAddresses
				SELECT [Email] FROM
				(
					SELECT [Email] FROM [qan].[Users] WITH (NOLOCK) WHERE [IdSid] = @VersionCreatedBy
					UNION
					SELECT DISTINCT [Email] FROM [qan].[OsatBuildCriteriaSetReviewers] WITH (NOLOCK) WHERE [VersionId] = @Id
				) AS T;
				SET @EmailTo = [qan].ToDelimitedString(@EmailAddresses, ';', '');

				-- review complete; create PRQ email
				IF (@EmailTemplateIdComplete IS NOT NULL)
				BEGIN
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
						, [VersionDescription]
						, [ReviewAtDescription]
						, [SentOn]
					)
					VALUES
					(
						  @Id                              -- [VersionId]
						, @EmailBatchId                    -- [BatchId]
						, @SnapshotReviewStageIdBefore     -- [SnapshotReviewStageId]
						, @ReviewStageIdBefore             -- [ReviewStageId]
						, @SnapshotReviewGroupId           -- [SnapshotReviewGroupId]
						, @ReviewGroupId                   -- [ReviewGroupId]
						, @EmailTemplateIdComplete         -- [EmailTemplateId]
						, @EmailTemplateNameComplete       -- [EmailTemplateName]
						, @EmailTo                         -- [To]
						, @VersionDescription              -- [VersionDescription]
						, @ReviewAtDescription             -- [ReviewAtDescription]
						, GETUTCDATE()                     -- [SentOn]
					);
					SET @CountEmails = @CountEmails + @@ROWCOUNT;
				END;
			END
			ELSE
			BEGIN
				-- review still in progress; create action emails if needed
				SELECT @ReviewStageIdAfter = MIN([ReviewStageId]), @ReviewStageDisplayNameAfter = MIN([DisplayName]) FROM [qan].[OsatBuildCriteriaSetReviewStages] WITH (NOLOCK) WHERE [Id] = @SnapshotReviewStageIdAfter;
				IF (@EmailTemplateIdAction IS NOT NULL AND @SnapshotReviewStageIdBefore <> @SnapshotReviewStageIdAfter) -- action emails already created for this stage if still on same snapshot stage id
				BEGIN
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
						, [Cc]
						, [VersionDescription]
						, [ReviewAtDescription]
						, [SentOn]
					)
					SELECT
						  @Id                                                                                                      -- [VersionId]
						, @EmailBatchId                                                                                            -- [BatchId]
						, @SnapshotReviewStageIdAfter                                                                              -- [SnapshotReviewStageId]
						, @ReviewStageIdAfter                                                                                      -- [ReviewStageId]
						, [Id]                                                                                                     -- [SnapshotReviewGroupId]
						, [ReviewGroupId]                                                                                          -- [ReviewGroupId]
						, @EmailTemplateIdAction                                                                                   -- [EmailTemplateId]
						, @EmailTemplateNameAction                                                                                 -- [EmailTemplateName]
						, [qan].[OsatBuildCriteriaSetReviewerEmailsAsDelimitedString](';', @Id, [ReviewStageId], [ReviewGroupId])  -- [To]
						, @VersionCreatedByEmail                                                                                   -- [Cc]
						, @VersionDescription                                                                                      -- [VersionDescription]
						, @ReviewStageDisplayNameAfter + ' > ' + [DisplayName]                                                     -- [ReviewAtDescription]
						, GETUTCDATE()                                                                                             -- [SentOn]
					FROM [qan].[OsatBuildCriteriaSetReviewGroups] WITH (NOLOCK)
					WHERE [VersionId] = @Id AND [ReviewStageId] = @ReviewStageIdAfter
					GROUP BY [Id], [ReviewStageId], [ReviewGroupId], [DisplayName];
					SET @CountEmails = @CountEmails + @@ROWCOUNT;
				END;
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
