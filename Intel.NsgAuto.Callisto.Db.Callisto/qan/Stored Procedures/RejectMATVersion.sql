
-- =============================================
-- Author:		jakemurx
-- Create date: 2020-11-16 16:50:12.690
-- Description:	Reject MAT version
--         EXEC [qan].[RejectMATVersion] 'jakemurx', 25, 1, 2, 61, 'Testing reject', null
-- =============================================
CREATE PROCEDURE [qan].[RejectMATVersion] 
	-- Add the parameters for the stored procedure here
	  @UserId VARCHAR(25)
	, @Id INT
	, @StageId int
	, @GroupId int
	, @ReviewerId int
	, @Comment varchar(1000)
	, @Override BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Count INT;
	DECLARE @CurrentStatus VARCHAR(25);
	DECLARE @CreatedBy VARCHAR(25);
	DECLARE @NewStatusId INT;
	DECLARE @On DATETIME2(7) = GETUTCDATE();

	SELECT @NewStatusId = MIN([Id]) FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Rejected';

	SELECT 
		@Count = COUNT(*)
		, @CurrentStatus = MIN(LTRIM(RTRIM(S.[Name])))
		, @CreatedBy = MIN(LTRIM(RTRIM(V.[CreatedBy]))) 
	FROM [qan].[MATVersions] AS V WITH (NOLOCK) 
	LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) 
		ON (V.[StatusId] = S.[Id]) 
	WHERE V.[Id] = @Id;

	IF (@Count > 0 AND @NewStatusId IS NOT NULL AND ((@CurrentStatus IN ('Submitted', 'In Review') AND @UserId IN (SELECT [Idsid] FROM [qan].[MATReviewers] WHERE [VersionId] = @Id)) OR @Override = 1))
	BEGIN
		UPDATE [qan].[MATVersions] 
			SET [StatusId] = @NewStatusId
			, [UpdatedBy] = @UserId
			, [UpdatedOn] = GETUTCDATE() 
		WHERE [Id] = @Id;
	END;

	--If NO reviewer for the specified Version, Stage, Group has voted (ie, a record exists in the MATReviewDecisions table), then insert the record
	--If a decision for the Version/Stage/Group exists, then do nothing
	--That is why we only look for VersionId, StageId, GroupId
	MERGE [qan].[MATReviewDecisions] AS TRG
	USING (SELECT VersionId=@Id, ReviewStageId=@StageId, ReviewGroupId=@GroupId, ReviewReviewerId=@ReviewerId, IsApproved=0, Comment=@Comment) AS SRC
		ON (TRG.[VersionId]=@Id AND TRG.[ReviewStageId]=@StageId AND TRG.[ReviewGroupId]=@GroupId) -- AND TRG.[ReviewReviewerId]=@ReviewerId )
	WHEN NOT MATCHED THEN
		INSERT ([VersionId], [ReviewStageId], [ReviewGroupId], [ReviewReviewerId], [IsApproved], [Comment], [ReviewedOn]) 
		VALUES (SRC.[VersionId], SRC.[ReviewStageId], SRC.[ReviewGroupId], SRC.[ReviewReviewerId], SRC.[IsApproved], SRC.[Comment], @On);

	DECLARE @StageName varchar(50);
	DECLARE @GroupName varchar(50);
	SELECT @StageName=S.StageName, @GroupName=G.GroupName
	FROM [qan].[MATReviewers] RR
		INNER JOIN [qan].[MATReviewGroups] G (NOLOCK) ON (G.Id=RR.ReviewGroupId)
		INNER JOIN [qan].[MATReviewStages] S (NOLOCK) ON (S.Id=RR.ReviewStageId)
		WHERE RR.Id=@ReviewerId

	DECLARE @Audit varchar(100) = (SELECT 'Review Rejected. Stage=' + @StageName + ', Group=' + @GroupName + ' Comment: ' + @Comment)

	EXEC [qan].[CreateMATChangeHistory] @Id, @Audit, @UserId

	EXEC [qan].[GetMATVersionDetails] @Id, @UserId;

	DECLARE @EmailTemplate varchar(50);
	SET @EmailTemplate='ReviewReject';

	-- Return the StageName
	DECLARE @CurrentStageId int;
	DECLARE @CurrentStageName varchar(50);
	EXEC [qan].[GetMATCurrentStage] @Id, @UserId, @CurrentStageId OUTPUT, @CurrentStageName OUTPUT

	SELECT @CurrentStageName AS 'StageName'

	DECLARE @SubmitterEmail as varchar(100)
	DECLARE @SubmitterName as varchar(100)

	SELECT @SubmitterEmail = [Email], @SubmitterName = [Name] 
	FROM [qan].[MATReviewers]  WITH (NOLOCK)
	WHERE [VersionId] = @Id
	AND   [Idsid] = (SELECT MAX([ChangedBy]) FROM [qan].[MATReviewChangeHistory] WHERE [VersionId] = @Id AND [Description] = @Audit);

	-- Return the email template, and requestor email
	SELECT @Id AS 'VersionId', @SubmitterEmail AS 'SubmitterEmail', @SubmitterName AS 'SubmitterName',
		  E.[Name], E.[Subject], X.[Value] AS [Body], E.[BodyXml] AS [Data]
	FROM  [ref].[EmailTemplates] AS E WITH (NOLOCK) INNER JOIN [ref].[EmailTemplateBodyXsls] AS X WITH (NOLOCK) ON (X.[Id] = E.[BodyXslId])
	WHERE E.[Name]=@EmailTemplate;

	-- Always return the additional requestors email/names
	--SELECT RequestId=@RequestId, RR.email AS AdditionalRequestorEmail, RR.[name] AS AdditionalRequestorName
	--FROM [tc].[RequestRequestors] RR 
	--WHERE RR.RequestId=@RequestId

	--Now go see which reviewers need to get an email.  First find out the current stage
	--its possible there are two (for in parallel stages).  Then return the reviewers - there may be NONE.
	DECLARE @StageId1 int = 0;
	DECLARE @StageId2 int = 0;
	DECLARE @IsUpdate bit = 0;
	EXEC [qan].[GetMATCurrentStagesForEmailing] @Id, @UserId, @IsUpdate, @StageId1 OUTPUT, @StageId2 OUTPUT

	--SELECT @StageId1 AS 'Stage Id 1'
	--SELECT @StageId2 AS 'Stage Id 2'

	--Send the email template for the reviewers.  Its either the default, set above, for when
	--the stage is approved and its time for the next stage.  Or the Reject template specific
	--for reviewers - different than the reject template for requestors
	SELECT VersionId=@Id, E.[Name], E.[Subject], X.[Value] AS [Body], E.[BodyXml] AS [Data]
	FROM [ref].[EmailTemplates] AS E WITH (NOLOCK) INNER JOIN [ref].[EmailTemplateBodyXsls] AS X WITH (NOLOCK) ON (X.[Id] = E.[BodyXslId])
	WHERE E.[Name]='ReviewRejectReviewer';

	--now return the reviewers that have work to do
	EXEC [qan].[GetMATReviewersWithWork] @Id, @StageId1, @StageId2, @UserId

END