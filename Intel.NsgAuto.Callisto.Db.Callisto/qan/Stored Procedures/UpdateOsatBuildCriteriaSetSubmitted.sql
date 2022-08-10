-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 17:50:24.260
-- Description  : Submits an osat build criteria set.
-- Note:        : This procedure contains the core logic, but is designed not to return any result sets
--                for maximum flexibility. If you want certain result sets, create a new procedure and
--                use composition. For example see [qan].[UpdateOsatBuildCriteriaSetSubmittedReturnDetails].
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatBuildCriteriaSetSubmitted] NULL, @Message OUTPUT, NULL, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid build criteria set: 0'
-- ===============================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatBuildCriteriaSetSubmitted]
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
	DECLARE @ActionType               VARCHAR(100) = 'Review Submit';
	DECLARE @ActionDescription        VARCHAR (1000) = @ActionType;
	DECLARE @BuildCombinationId       INT;
	DECLARE @Count                    INT;
	DECLARE @CountEmails              INT = 0;
	DECLARE @CreatedBy                VARCHAR(25);
	DECLARE @CurrentStatusId          INT;
	DECLARE @DesignFamilyName         VARCHAR(10);
	DECLARE @ErrorsExist              BIT = 0;
	DECLARE @EmailTemplateIdSubmit    INT;
	DECLARE @EmailTemplateNameSubmit  VARCHAR(50) = 'ReviewSubmit';
	DECLARE @EmailTemplateIdAction    INT;
	DECLARE @EmailTemplateNameAction  VARCHAR(50) = 'ReviewAction';
	DECLARE @NewStatusId              INT = 3; -- Submitted
	DECLARE @On                       DATETIME2(7) = GETUTCDATE();
	DECLARE @ReviewStageId            INT;
	DECLARE @ReviewStageDisplayName   VARCHAR(100);
	DECLARE @ReviewTypeDescription    VARCHAR(50) = 'OSAT Build Criteria Set';
	DECLARE @ReviewTypeId             INT;
	DECLARE @SnapshotReviewStageId    BIGINT;
	DECLARE @VersionDescription       VARCHAR(500);

	SET @Succeeded = 0;
	SET @Message = NULL;
	SET @EmailBatchId = NULL;

	SELECT
		  @Count              = COUNT(*)
		, @CurrentStatusId    = MAX([StatusId])
		, @CreatedBy          = MAX([CreatedBy])
		, @BuildCombinationId = MAX([BuildCombinationId])
		, @DesignFamilyName   = MAX([BuildCombinationDesignFamilyName])
		, @VersionDescription = MAX([BuildCombinationIntelProdName]) + ' ' + MAX([BuildCombinationMaterialMasterField]) + ' ' + MAX([BuildCombinationAssyUpi]) + ' [Version ' + CAST(MAX([Version]) AS VARCHAR(20)) + ']'
	FROM [qan].[FOsatBuildCriteriaSets](@Id, @UserId, NULL, NULL, NULL, NULL, NULL);

	IF (@DesignFamilyName IS NOT NULL) SET @ReviewTypeDescription = @ReviewTypeDescription + ' ' + @DesignFamilyName;

	SELECT @ReviewTypeId = MIN([Id]) FROM [ref].[ReviewTypes] WITH (NOLOCK) WHERE [Description] = @ReviewTypeDescription;

	SELECT @EmailTemplateIdSubmit = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameSubmit;
	SELECT @EmailTemplateIdAction = MIN([Id]) FROM [ref].[EmailTemplates] WITH (NOLOCK) WHERE [Name] = @EmailTemplateNameAction;

	-- standardization
	IF (@Override IS NULL) SET @Override = 0;

	-- begin validation
	IF (NOT @Count = 1)
	BEGIN
		SET @Message = 'Invalid build criteria set: ' + ISNULL(CAST(@Id AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END
	ELSE IF (@ReviewTypeId IS NULL)
	BEGIN
		SET @Message = 'Review type does not exist: ' + @ReviewTypeDescription;
		SET @ErrorsExist = 1;
	END
	-- if @Override = 1 skip the validation inside the BEGIN/END block
	ELSE IF (@Override = 0)
	BEGIN
		IF (@CurrentStatusId IS NULL OR @CurrentStatusId <> 1) -- 1 = Draft
		BEGIN
			SET @Message = 'Submit is not allowed for the current status';
			SET @ErrorsExist = 1;
		END;
		-- for now, only the user who created it may submit it
		ELSE IF (@UserId IS NULL OR @UserId <> @CreatedBy)
		BEGIN
			SET @Message = 'Unauthorized';
			SET @ErrorsExist = 1;
		END;
	END;

	IF (@ErrorsExist = 0)
	BEGIN
		IF (EXISTS(SELECT 1 FROM [qan].[OsatBuildCriteriaSetReviewStages] WHERE [VersionId] = @Id))
		BEGIN
			IF (@Override = 1)
			BEGIN
				EXEC [qan].[CleanOsatBuildCriteriaSetReview] @Id, @UserId;
			END;
			ELSE
			BEGIN
				SET @Message = 'At least one review stage already exists';
				SET @ErrorsExist = 1;
			END;
		END;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION
			-- [qan].[OsatBuildCriteriaSetReviewStages]
			SELECT
				  RTRS.[Id] AS [ReviewTypeReviewStageId]
				, RS.[Id] AS [ReviewStageId]
				, RS.[StageName]
				, RS.[DisplayName]
				, RS.[Sequence]
				, RS.[ParentStageId]
				, ISNULL(RS.[IsNextInParallel], 0) AS [IsNextInParallel]
			INTO #TempStages
			FROM [qan].[ReviewTypeReviewStages] AS RTRS WITH (NOLOCK)
			INNER JOIN [qan].[ReviewStages] AS RS WITH (NOLOCK) ON (RS.[Id] = RTRS.[ReviewStageId])
			WHERE RTRS.[ReviewTypeId] = @ReviewTypeId AND RS.[IsActive] = 1;

			INSERT INTO [qan].[OsatBuildCriteriaSetReviewStages]
			(
				  [VersionId]
				, [ReviewStageId]
				, [StageName]
				, [DisplayName]
				, [Sequence]
				, [ParentStageId]
				, [IsNextInParallel]
			)
			SELECT
				  @Id
				, [ReviewStageId]
				, [StageName]
				, [DisplayName]
				, [Sequence]
				, [ParentStageId]
				, [IsNextInParallel]
			FROM #TempStages;

			SET @ActionDescription = @ActionDescription + '; Stages: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

			-- [qan].[OsatBuildCriteriaSetReviewGroups]
			SELECT
				  RSRG.[Id] AS [ReviewStageReviewGroupId]
				, RTRS.[ReviewStageId]
				, G.[Id] AS [ReviewGroupId]
				, G.[GroupName]
				, G.[DisplayName]
			INTO #TempGroups
			FROM [qan].[ReviewStageReviewGroups] AS RSRG WITH (NOLOCK)
			INNER JOIN [qan].[ReviewTypeReviewStages] AS RTRS WITH (NOLOCK) ON (RTRS.[Id] = RSRG.[ReviewTypeReviewStageId])
			INNER JOIN [qan].[ReviewGroups] AS G WITH (NOLOCK) ON (G.[Id] = RSRG.[ReviewGroupId])
			WHERE RSRG.[ReviewTypeReviewStageId] IN (SELECT [ReviewTypeReviewStageId] FROM #TempStages) AND G.[IsActive] = 1; 

			INSERT INTO [qan].[OsatBuildCriteriaSetReviewGroups]
			(
				  [VersionId]
				, [ReviewStageId]
				, [ReviewGroupId]
				, [GroupName]
				, [DisplayName]
			)
			SELECT
				  @Id
				, [ReviewStageId]
				, [ReviewGroupId]
				, [GroupName]
				, [DisplayName]
			FROM #TempGroups;

			SET @ActionDescription = @ActionDescription + '; Groups: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

			-- [qan].[OsatBuildCriteriaSetReviewers]
			SELECT
				  RTRS.[ReviewStageId]
				, RSRG.[ReviewGroupId]
				, R.[Id] AS [ReviewerId]
				, R.[Name]
				, R.[Idsid]
				, R.[Wwid]
				, R.[Email]
			INTO #TempReviewers
			FROM [qan].[ReviewGroupReviewers] AS RGR WITH (NOLOCK)
			INNER JOIN [qan].[ReviewStageReviewGroups] AS RSRG WITH (NOLOCK) ON (RSRG.[Id] = RGR.[ReviewStageReviewGroupId])
			INNER JOIN [qan].[ReviewTypeReviewStages] AS RTRS WITH (NOLOCK) ON (RTRS.[Id] = RSRG.[ReviewTypeReviewStageId])
			INNER JOIN [qan].[ReviewGroups] AS G WITH (NOLOCK) ON (G.[Id] = RSRG.[ReviewGroupId])
			INNER JOIN [qan].[Reviewers] AS R WITH (NOLOCK) ON (R.[Id] = RGR.[ReviewerId])
			WHERE RGR.[ReviewStageReviewGroupId] IN (SELECT [ReviewStageReviewGroupId] FROM #TempGroups) AND R.[IsActive] = 1;

			INSERT INTO [qan].[OsatBuildCriteriaSetReviewers]
			(
				  [VersionId]
				, [ReviewStageId]
				, [ReviewGroupId]
				, [ReviewerId]
				, [Name]
				, [Idsid]
				, [Wwid]
				, [Email]
			)
			SELECT
				  @Id
				, [ReviewStageId]
				, [ReviewGroupId]
				, [ReviewerId]
				, [Name]
				, [Idsid]
				, [Wwid]
				, [Email]
			FROM #TempReviewers;

			SET @ActionDescription = @ActionDescription + '; Reviewers: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

			DROP TABLE #TempStages;
			DROP TABLE #TempGroups;
			DROP TABLE #TempReviewers;

			-- cancel any existing versions in Submitted, or In Review status matching the build combination id
			UPDATE [qan].[OsatBuildCriteriaSets] SET
				  [StatusId] = 2 -- Canceled
				, [UpdatedBy] = @UserId
				, [UpdatedOn] = @On
			WHERE [StatusId] IN (3, 5) -- Submitted, or In Review
			  AND [BuildCombinationId] = @BuildCombinationId
			  AND [Id] <> @Id;

			UPDATE [qan].[OsatBuildCriteriaSets] SET [StatusId] = @NewStatusId, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id AND StatusId <> 2;

			SELECT TOP 1 @SnapshotReviewStageId = [Id], @ReviewStageId = [ReviewStageId], @ReviewStageDisplayName = [DisplayName] FROM [qan].[OsatBuildCriteriaSetReviewStages] WITH (NOLOCK) WHERE [VersionId] = @Id ORDER BY [Sequence] ASC, [Id] ASC;

			SELECT @EmailBatchId = ISNULL(MAX([BatchId]), 0) + 1 FROM [qan].[OsatBuildCriteriaSetReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id;

			IF (@EmailTemplateIdSubmit IS NOT NULL)
			BEGIN
				INSERT INTO [qan].[OsatBuildCriteriaSetReviewEmails]
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
					  @Id                        -- VersionId
					, @EmailBatchId              -- BatchId
					, @SnapshotReviewStageId     -- SnapshotReviewStageId
					, @ReviewStageId             -- ReviewStageId
					, @EmailTemplateIdSubmit     -- EmailTemplateId
					, @EmailTemplateNameSubmit   -- EmailTemplateName
					, [Email]                    -- To
					, [Name]                     -- RecipientName
					, @VersionDescription        -- VersionDescription
					, @ReviewStageDisplayName    -- ReviewAtDescription
					, GETUTCDATE()               -- SentOn
				FROM [qan].[Users] WITH (NOLOCK) WHERE [IdSid] = @UserId;
				SET @CountEmails = @CountEmails + @@ROWCOUNT;
			END;

			IF (@EmailTemplateIdAction IS NOT NULL)
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
				SELECT
					  @Id                                                                                                      -- VersionId
					, @EmailBatchId                                                                                            -- BatchId
					, @SnapshotReviewStageId                                                                                   -- SnapshotReviewStageId
					, @ReviewStageId                                                                                           -- ReviewStageId
					, [Id]                                                                                                     -- SnapshotReviewGroupId
					, [ReviewGroupId]                                                                                          -- ReviewGroupId
					, @EmailTemplateIdAction                                                                                   -- EmailTemplateId
					, @EmailTemplateNameAction                                                                                 -- EmailTemplateName
					, [qan].[OsatBuildCriteriaSetReviewerEmailsAsDelimitedString](';', @Id, [ReviewStageId], [ReviewGroupId])  -- To
					, @VersionDescription                                                                                      -- VersionDescription
					, @ReviewStageDisplayName + ' > ' + [DisplayName]                                                          -- ReviewAtDescription
					, GETUTCDATE()                                                                                             -- SentOn
				FROM [qan].[OsatBuildCriteriaSetReviewGroups] WITH (NOLOCK)
				WHERE [VersionId] = @Id AND [ReviewStageId] = @ReviewStageId
				GROUP BY [Id], [ReviewStageId], [ReviewGroupId], [DisplayName];
				SET @CountEmails = @CountEmails + @@ROWCOUNT;
			END;

			IF (@CountEmails = 0) SET @EmailBatchId = NULL; -- make sure it is set to null if no email records were inserted

			SET @ActionDescription = @ActionDescription + '; Emails: ' + CAST(@CountEmails AS VARCHAR(20));

			EXEC [qan].[CreateOsatBuildCriteriaSetReviewChangeHistory] NULL, @Id, @ActionDescription, @UserId;
		COMMIT;
		SET @Succeeded = 1;
	END;

	IF (@Override = 1) SET @ActionDescription = @ActionDescription + '; Override = 1';
	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', @ActionType, 'OsatBuildCriteriaSet', @Id, NULL, @Succeeded, @Message;

END
