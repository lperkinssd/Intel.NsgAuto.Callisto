
-- =========================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 17:10:27.030
-- Description  : Approves an auto checker build criteria
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateAcBuildCriteriaApproved] NULL, @Message OUTPUT, NULL, 'bricschx', 0, 0, 'Test comment';
--                PRINT @Message; -- should print: 'Invalid build criteria: 0'
-- =========================================================================================================================
CREATE PROCEDURE [qan].[PublishAcBuildCriteriaApproved]
(
	  @Succeeded           BIT                   OUTPUT
	, @Message             VARCHAR(500)          OUTPUT
	, @EmailBatchId        INT                   OUTPUT
	, @UserId              VARCHAR(25)
	, @Id                  BIGINT
	, @SnapshotReviewerId  BIGINT
	, @Comment             VARCHAR(1000) = NULL
	, @Override            BIT           = 0
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionType                     VARCHAR(100) = 'Review Approve';
	DECLARE @ActionDescription              VARCHAR (1000) = @ActionType + '; SnapshotReviewerId = ' + CAST(@SnapshotReviewerId AS VARCHAR(20));
	DECLARE @AssociatedEntityId             BIGINT;
	DECLARE @AssociatedEntityType           VARCHAR(100);
	DECLARE @BuildCombinationId             INT;
	DECLARE @BuildRuleId                    INT;
	DECLARE @Count                          INT;
	DECLARE @CountGroupsNoDecision          INT;
	DECLARE @CountEmails                    INT = 0;
	DECLARE @CurrentStatusId                INT;
	DECLARE @DesignIdTreadstone             VARCHAR(10);
	DECLARE @EffectiveOn                    DATETIME2(7);
	DECLARE @EffectiveOnDelayDays           INT = 2;
	DECLARE @ErrorsExist                    BIT = 0;
	DECLARE @EmailAddresses                 [qan].[IStrings];
	DECLARE @EmailTemplateIdAction          INT;
	DECLARE @EmailTemplateNameAction        VARCHAR(50) = 'ReviewAction';
	DECLARE @EmailTemplateIdApprove         INT;
	DECLARE @EmailTemplateNameApprove       VARCHAR(50) = 'ReviewApprove';
	DECLARE @EmailTemplateIdComplete        INT;
	DECLARE @EmailTemplateNameComplete      VARCHAR(50) = 'ReviewComplete';
	DECLARE @EmailTo                        VARCHAR(2000);
	DECLARE @FabricationFacilityTreadstone  VARCHAR(50);
	DECLARE @IsLastApproval                 BIT = 0;
	DECLARE @ProbeConversionIdTreadstone    VARCHAR(50);
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
	DECLARE @TestFlowTreadstone             VARCHAR(50);
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
		, @DesignIdTreadstone            = ISNULL(MAX([DesignName]), '')
		, @FabricationFacilityTreadstone = ISNULL(MAX([FabricationFacilityName]), '')
		, @TestFlowTreadstone            = ISNULL(MAX([TestFlowName]), '')
		, @ProbeConversionIdTreadstone   = ISNULL(MAX([ProbeConversionName]), '')
		, @VersionDescription            = MAX([BuildCombinationName]) + ' [Version ' + CAST(MAX([Version]) AS VARCHAR(20)) + ']'
	FROM [qan].[FAcBuildCriterias](@Id, @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	WHERE DesignName = 'Optane'

	SET @SnapshotReviewStageIdBefore = [qan].[FGetAcBuildCriteriaReviewCurrentSnapshotStageId](@Id);
	SELECT @ReviewStageIdBefore = MIN([ReviewStageId]) FROM [qan].[AcBuildCriteriaReviewStages] WITH (NOLOCK) WHERE [Id] = @SnapshotReviewStageIdBefore;

	SELECT @CountGroupsNoDecision = COUNT(*), @ReviewGroupIdNoDecision = MAX([ReviewGroupId]) FROM [qan].[FAcBuildCriteriaReviewGroupsNoDecision](@Id);

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
		SET @Message = 'Invalid build criteria: ' + ISNULL(CAST(@Id AS VARCHAR(20)), '');
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
		FROM [qan].[AcBuildCriteriaReviewers] WHERE [Id] = @SnapshotReviewerId;

		SELECT @SnapshotReviewGroupId = MAX([Id]) FROM [qan].[AcBuildCriteriaReviewGroups] WITH (NOLOCK) WHERE [VersionId] = @Id AND [ReviewGroupId] = @ReviewGroupId;

		SELECT @ReviewAtDescription = ISNULL(MIN(S.[DisplayName]), '') + ' > ' + ISNULL(MIN(G.[DisplayName]), '')
		FROM [qan].[AcBuildCriteriaReviewGroups] AS G WITH (NOLOCK)
		INNER JOIN [qan].[AcBuildCriteriaReviewStages] AS S WITH (NOLOCK) ON (S.[VersionId] = G.[VersionId] AND S.[ReviewStageId] = G.[ReviewStageId])
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
		-- last approval, and the treadstone database will need to be updated with the current build criteria
		-- however, before doing it for real, this block attempts to make sure no issues will occur
		BEGIN TRY
			-- the following performs an update statement but the where clause condition 0 = 1 ensures no rows will actually be updated
			-- if the following statement is successful (i.e. does not enter the catch block) then all of the following should be true
			-- (1) the treadstone database is up
			-- (2) the TREADSTONE linked server is working
			-- (3) we have the proper permission to update the treadstone [build_rule] table
			--UPDATE TOP (1) [TREADSTONE].[treadstone].[dbo].[build_rule] SET [lastmodified_by] = [lastmodified_by] WHERE 0 = 1;
			UPDATE TOP (1) [qan].[build_rule_TEMP] SET [lastmodified_by] = [lastmodified_by] WHERE 0 = 1;
		END TRY
		BEGIN CATCH
			SET @Message = 'There was an issue connecting to the treadstone database';
			SET @ErrorsExist = 1;
		END CATCH;
	END;

	IF (@ErrorsExist = 0)
	BEGIN
		-- would like to wrap in a transaction, but can't currently because distributed transactions are not supported between the two databases
		--BEGIN TRANSACTION

			-- do the treadstone update first so if it fails, Callisto won't be updated and it can be re-attempted later
			IF (@IsLastApproval = 1)
			BEGIN
				SET @EffectiveOn = DATEADD(DAY, @EffectiveOnDelayDays, GETUTCDATE());

				-- begin treadstone update
				-- determine if build_rule record exists and if so get the build_rule_id
				SELECT
					  @Count = COUNT(*)
					, @BuildRuleId = MAX([build_rule_id])
				--FROM [TREADSTONE].[treadstone].[dbo].[build_rule] WITH (NOLOCK)
				FROM [qan].[build_rule_TEMP] WITH (NOLOCK)
				
				WHERE [design_id]            = @DesignIdTreadstone
				  AND [fabrication_facility] = @FabricationFacilityTreadstone
				  AND [test_flow]            = @TestFlowTreadstone
				  AND [prb_conv_id]          = @ProbeConversionIdTreadstone;

				IF (@Count = 1 AND @BuildRuleId IS NOT NULL)
				BEGIN
					--UPDATE [TREADSTONE].[treadstone].[dbo].[build_rule] SET
					UPDATE [qan].[build_rule_TEMP] SET					
						  [lastmodified_by] = @VersionCreatedBy
						, [lastmodified_date] = GETUTCDATE()
					WHERE [build_rule_id] = @BuildRuleId;
				END
				ELSE IF (@Count = 0)
				BEGIN
					--INSERT [TREADSTONE].[treadstone].[dbo].[build_rule]
					INSERT [qan].[build_rule_TEMP]					
					(
						  [design_id]
						, [fabrication_facility]
						, [test_flow]
						, [prb_conv_id]
						, [created_by]
						, [created_date]
						, [lastmodified_by]
						, [lastmodified_date]
					)
					VALUES
					(
						  @DesignIdTreadstone
						, @FabricationFacilityTreadstone
						, @TestFlowTreadstone
						, @ProbeConversionIdTreadstone
						, @VersionCreatedBy
						, GETUTCDATE()
						, @VersionCreatedBy
						, GETUTCDATE()
					);

					-- get the build_rule_id for the record just inserted
					SELECT
						  @Count = COUNT(*)
						, @BuildRuleId = MAX([build_rule_id])
					--FROM [TREADSTONE].[treadstone].[dbo].[build_rule] WITH (NOLOCK)
					FROM [qan].[build_rule_TEMP] WITH (NOLOCK)					
					WHERE [design_id]            = @DesignIdTreadstone
					  AND [fabrication_facility] = @FabricationFacilityTreadstone
					  AND [test_flow]            = @TestFlowTreadstone
					  AND [prb_conv_id]          = @ProbeConversionIdTreadstone;

					IF (NOT @Count = 1 OR @BuildRuleId IS NULL)
					BEGIN
						RAISERROR('Treadstone: build_rule_id could not be determined', 16, 1);
					END;
				END
				ELSE IF (@Count > 1)
				BEGIN
					RAISERROR('Treadstone: multiple entries in the [build_rule] table for the combination [design_id], [fabrication_facility], [test_flow], and [prb_conv_id]', 16, 1);
				END
				ELSE
				BEGIN
					RAISERROR('Treadstone: build_rule_id could not be determined', 16, 1);
				END;

				-- delete all condition records for the build_rule_id
				--DELETE FROM [TREADSTONE].[treadstone].[dbo].[build_rule_condition] WHERE [build_rule_id] = @BuildRuleId;
				DELETE FROM [qan].[build_rule_TEMP] WHERE [build_rule_id] = @BuildRuleId;
				

				-- insert all condition records for the build_rule_id
				--INSERT INTO [TREADSTONE].[treadstone].[dbo].[build_rule_condition]
				INSERT INTO [qan].[build_rule_condition_TEMP]
				(
					  [column_name]
					, [column_operator]
					, [operator]
					, [column_value]
					, [build_rule_id]
					, [created_by]
					, [created_date]
					, [lastmodified_by]
					, [lastmodified_date]
				)
				SELECT
					  [AttributeTypeName]
					, 'AND'
					, [ComparisonOperationKeyTreadstone]
					, [Value]
					, @BuildRuleId
					, @VersionCreatedBy
					, GETUTCDATE()
					, @VersionCreatedBy
					, GETUTCDATE()
				FROM [qan].[FAcBuildCriteriaConditions](NULL, @UserId, @Id, NULL, NULL, NULL, NULL, NULL);
				-- end treadstone update

				-- unset the IsPOR field for any that match the build combination id
				UPDATE [qan].[AcBuildCriterias] SET [IsPOR] = 0, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [IsPOR] = 1 AND [BuildCombinationId] = @BuildCombinationId;

				UPDATE [qan].[AcBuildCriterias] SET [IsPOR] = 1, [StatusId] = 6, [EffectiveOn] = @EffectiveOn, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id; -- StatusId 6 = Complete

			END -- is last approval
			ELSE If (@CurrentStatusId = 3) -- Submitted
			BEGIN
				UPDATE [qan].[AcBuildCriterias] SET [StatusId] = 5, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id; -- StatusId 5 = In Review
			END;

			INSERT INTO [qan].[AcBuildCriteriaReviewDecisions]
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
			SET @AssociatedEntityType = 'AcBuildCriteriaReviewDecision';

			SET @SnapshotReviewStageIdAfter = [qan].[FGetAcBuildCriteriaReviewCurrentSnapshotStageId](@Id);

			SELECT @EmailBatchId = ISNULL(MAX([BatchId]), 0) + 1 FROM [qan].[AcBuildCriteriaReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id;

			IF (@EmailTemplateIdApprove IS NOT NULL)
			BEGIN
				SET @EmailTo = [qan].[AcBuildCriteriaReviewerEmailsAsDelimitedString](';', @Id, NULL, @ReviewGroupId);

				INSERT INTO [qan].[AcBuildCriteriaReviewEmails]
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
					SELECT DISTINCT [Email] FROM [qan].[AcBuildCriteriaReviewers] WITH (NOLOCK) WHERE [VersionId] = @Id
				) AS T;
				SET @EmailTo = [qan].ToDelimitedString(@EmailAddresses, ';', '');

				-- review complete; create PRQ email
				IF (@EmailTemplateIdComplete IS NOT NULL)
				BEGIN
					INSERT INTO [qan].[AcBuildCriteriaReviewEmails]
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
				SELECT @ReviewStageIdAfter = MIN([ReviewStageId]), @ReviewStageDisplayNameAfter = MIN([DisplayName]) FROM [qan].[AcBuildCriteriaReviewStages] WITH (NOLOCK) WHERE [Id] = @SnapshotReviewStageIdAfter;
				IF (@EmailTemplateIdAction IS NOT NULL AND @SnapshotReviewStageIdBefore <> @SnapshotReviewStageIdAfter) -- action emails already created for this stage if still on same snapshot stage id
				BEGIN
					INSERT INTO [qan].[AcBuildCriteriaReviewEmails]
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
						  @Id                                                                                                 -- [VersionId]
						, @EmailBatchId                                                                                       -- [BatchId]
						, @SnapshotReviewStageIdAfter                                                                         -- [SnapshotReviewStageId]
						, @ReviewStageIdAfter                                                                                 -- [ReviewStageId]
						, [Id]                                                                                                -- [SnapshotReviewGroupId]
						, [ReviewGroupId]                                                                                     -- [ReviewGroupId]
						, @EmailTemplateIdAction                                                                              -- [EmailTemplateId]
						, @EmailTemplateNameAction                                                                            -- [EmailTemplateName]
						, [qan].[AcBuildCriteriaReviewerEmailsAsDelimitedString](';', @Id, [ReviewStageId], [ReviewGroupId])  -- [To]
						, @VersionCreatedByEmail                                                                              -- [Cc]
						, @VersionDescription                                                                                 -- [VersionDescription]
						, @ReviewStageDisplayNameAfter + ' > ' + [DisplayName]                                                -- [ReviewAtDescription]
						, GETUTCDATE()                                                                                        -- [SentOn]
					FROM [qan].[AcBuildCriteriaReviewGroups] WITH (NOLOCK)
					WHERE [VersionId] = @Id AND [ReviewStageId] = @ReviewStageIdAfter
					GROUP BY [Id], [ReviewStageId], [ReviewGroupId], [DisplayName];
					SET @CountEmails = @CountEmails + @@ROWCOUNT;
				END;
			END;

			IF (@CountEmails = 0) SET @EmailBatchId = NULL; -- make sure it is set to null if no email records were inserted

			SET @ActionDescription = @ActionDescription + '; Emails: ' + CAST(@CountEmails AS VARCHAR(20));

			EXEC [qan].[CreateAcBuildCriteriaReviewChangeHistory] NULL, @Id, @ActionDescription, @UserId;

		--COMMIT;
		SET @Succeeded = 1;
	END;

	IF (@Override = 1) SET @ActionDescription = @ActionDescription + '; Override = 1';
	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'Auto Checker', @ActionType, 'AcBuildCriteria', @Id, NULL, @Succeeded, @Message, @AssociatedEntityType, @AssociatedEntityId;

END