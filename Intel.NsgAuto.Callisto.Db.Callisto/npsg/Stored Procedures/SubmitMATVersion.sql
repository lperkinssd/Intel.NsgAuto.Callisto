


-- ============================================================================
-- Author       : jakemurx
-- Create date  : 2020-09-28 10:48:45.315
-- Description  : Submits a MAT version
-- Example      : EXEC [npsg].[SubmitMATVersion] 'bricschx', 1
-- ============================================================================
CREATE PROCEDURE [npsg].[SubmitMATVersion]
(
	  @UserId VARCHAR(25)
	, @Id INT
	, @Override BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT;
	DECLARE @CurrentStatus VARCHAR(25);
	DECLARE @CreatedBy VARCHAR(25);
	DECLARE @NewStatusId INT;

	SELECT @NewStatusId = MIN([Id]) FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Submitted';

	SELECT 
		@Count = COUNT(*)
		, @CurrentStatus = MIN(LTRIM(RTRIM(S.[Name])))
		, @CreatedBy = MIN(LTRIM(RTRIM(V.[CreatedBy]))) 
	FROM [npsg].[MATVersions] AS V WITH (NOLOCK) 
	LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) 
		ON (V.[StatusId] = S.[Id]) 
	WHERE V.[Id] = @Id;

	IF (@Count > 0 AND @NewStatusId IS NOT NULL AND ((@CurrentStatus = 'Draft' AND @UserId = @CreatedBy) OR @Override = 1))
	BEGIN
		UPDATE [npsg].[MATVersions] 
			SET [StatusId] = @NewStatusId
			, [UpdatedBy] = @UserId
			, [UpdatedOn] = GETUTCDATE() 
		WHERE [Id] = @Id;

		-- Create review snapshots
		EXEC [npsg].[CreateMATSnapshots] @Id
	END;

	DECLARE @cmt varchar(MAX);
	SET @cmt = 'Request Submitted';

	EXEC [npsg].[CreateMATChangeHistory] @Id, @cmt, @UserId
	
	EXEC [npsg].[GetMATVersionDetails] @Id, @UserId;

	DECLARE @EmailTemplate varchar(50);
	SET @EmailTemplate='ReviewSubmit';

	-- Return the StageName
	DECLARE @StageId int;
	DECLARE @StageName varchar(50);
	EXEC [npsg].[GetMATCurrentStage] @Id, @UserId, @StageId OUTPUT, @StageName OUTPUT

	SELECT @StageName AS 'StageName'

	DECLARE @SubmitterEmail as varchar(100)
	DECLARE @SubmitterName as varchar(100)

	SELECT @SubmitterEmail = [Email], @SubmitterName = [Name] 
	FROM [npsg].[MATReviewers]  WITH (NOLOCK)
	WHERE [VersionId] = @Id
	AND   [Idsid] = @UserId;

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
	EXEC [npsg].[GetMATCurrentStagesForEmailing] @Id, @UserId, @IsUpdate, @StageId1 OUTPUT, @StageId2 OUTPUT

	--SELECT @StageId1 AS 'Stage Id 1'
	--SELECT @StageId2 AS 'Stage Id 2'

	--Send the email template for the reviewers.  Its either the default, set above, for when
	--the stage is approved and its time for the next stage.  Or the Reject template specific
	--for reviewers - different than the reject template for requestors
	SELECT VersionId=@Id, E.[Name], E.[Subject], X.[Value] AS [Body], E.[BodyXml] AS [Data]
	FROM [ref].[EmailTemplates] AS E WITH (NOLOCK) INNER JOIN [ref].[EmailTemplateBodyXsls] AS X WITH (NOLOCK) ON (X.[Id] = E.[BodyXslId])
	WHERE E.[Name]='ReviewAction';

	--now return the reviewers that have work to do
	EXEC [npsg].[GetMATReviewersWithWork] @Id, @StageId1, @StageId2, @UserId
END