



-- ============================================================================
-- Author       : jakemurx
-- Create date  : 2020-11-19 16:32:49.962
-- Description  : Cancel a MAT version
-- Example      : EXEC [qan].[CancelMATVersion] 'bricschx', 1
-- ============================================================================
CREATE PROCEDURE [qan].[CancelMATVersion]
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
	DECLARE @On DATETIME2(7) = GETUTCDATE();

	SELECT @NewStatusId = MIN([Id]) FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Canceled';

	SELECT 
		@Count = COUNT(*)
		, @CurrentStatus = MIN(LTRIM(RTRIM(S.[Name])))
		, @CreatedBy = MIN(LTRIM(RTRIM(V.[CreatedBy])))
	FROM [qan].[MATVersions] AS V WITH (NOLOCK) 
	LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) 
		ON (V.[StatusId] = S.[Id]) 
	WHERE V.[Id] = @Id;

	IF (@Count > 0 AND @NewStatusId IS NOT NULL AND ((@CurrentStatus = 'Draft' AND @UserId = @CreatedBy) OR @Override = 1))
	BEGIN
		UPDATE [qan].[MATVersions] 
			SET [StatusId] = @NewStatusId
			, [UpdatedBy] = @UserId
			, [UpdatedOn] = GETUTCDATE() 
		WHERE [Id] = @Id;
	END;

	DECLARE @cmt varchar(MAX);
	SET @cmt = 'Request Cancelled';

	EXEC [qan].[CreateMATChangeHistory] @Id, @cmt, @UserId
	
	EXEC [qan].[GetMATVersionDetails] @Id, @UserId;

	DECLARE @EmailTemplate varchar(50);
	SET @EmailTemplate='ReviewCancel';

	-- Return the empty StageName because there are not snapshot tables with stages
	--DECLARE @StageId int;
	DECLARE @StageName varchar(50) = '';
	--EXEC [qan].[GetMATCurrentStage] @Id, @UserId, @StageId OUTPUT, @StageName OUTPUT

	SELECT @StageName AS 'StageName'

	DECLARE @SubmitterEmail as varchar(100)
	DECLARE @SubmitterName as varchar(100)

	SELECT @SubmitterEmail = [Email], @SubmitterName = [Name] 
	FROM [qan].[Reviewers]  WITH (NOLOCK)
	WHERE [Idsid] = @UserId;

	-- Return the email template, and requestor email
	SELECT @Id AS 'VersionId', @SubmitterEmail AS 'SubmitterEmail', @SubmitterName AS 'SubmitterName',
		  E.[Name], E.[Subject], X.[Value] AS [Body], E.[BodyXml] AS [Data]
	FROM  [ref].[EmailTemplates] AS E WITH (NOLOCK) INNER JOIN [ref].[EmailTemplateBodyXsls] AS X WITH (NOLOCK) ON (X.[Id] = E.[BodyXslId])
	WHERE E.[Name]=@EmailTemplate;

	-- Always return the additional requestors email/names
	--SELECT RequestId=@RequestId, RR.email AS AdditionalRequestorEmail, RR.[name] AS AdditionalRequestorName
	--FROM [tc].[RequestRequestors] RR 
	--WHERE RR.RequestId=@RequestId

	----Now go see which reviewers need to get an email.  First find out the current stage
	----its possible there are two (for in parallel stages).  Then return the reviewers - there may be NONE.
	--DECLARE @StageId1 int = 0;
	--DECLARE @StageId2 int = 0;
	--DECLARE @IsUpdate bit = 0;
	--EXEC [qan].[GetMATCurrentStagesForEmailing] @Id, @UserId, @IsUpdate, @StageId1 OUTPUT, @StageId2 OUTPUT

	----SELECT @StageId1 AS 'Stage Id 1'
	----SELECT @StageId2 AS 'Stage Id 2'

	----Send the email template for the reviewers.  Its either the default, set above, for when
	----the stage is approved and its time for the next stage.  Or the Reject template specific
	----for reviewers - different than the reject template for requestors
	--SELECT VersionId=@Id, E.[Name], E.[Subject], E.[Body], E.[Data], E.[LanguageCode]
	--FROM [ref].[EmailTemplates] E WITH (NOLOCK)
	--WHERE E.[Name]='ReviewAction';

	----now return the reviewers that have work to do
	--EXEC [qan].[GetMATReviewersWithWork] @Id, @StageId1, @StageId2, @UserId
END