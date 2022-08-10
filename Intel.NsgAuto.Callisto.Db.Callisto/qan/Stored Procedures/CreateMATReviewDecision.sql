

-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-14 13:57:25.519
-- Description:	Create a MAT review decision
-- =============================================
CREATE PROCEDURE [qan].[CreateMATReviewDecision]
	-- Add the parameters for the stored procedure here
	@VersionId int,
	@StageId int,
	@GroupId int,
	@Approved bit,
	@ReviewerId int,
	@Comment [varchar](1000),
	@UserId [varchar](255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @On DATETIME2(7) = GETUTCDATE();
	DECLARE @Completed int;	
	DECLARE @Rejected int;
	DECLARE @InReview int;

	SELECT @Completed = (SELECT [Id] FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Completed')
	SELECT @Rejected = (SELECT [Id] FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Rejected')
	SELECT @InReview = (SELECT [Id] FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'In Review')
	
	--If NO reviewer for the specified Version, Stage, Group has voted (ie, a record exists in the MATReviewDecisions table), then insert the record
	--If a decision for the Version/Stage/Group exists, then do nothing
	--That is why we only look for VersionId, StageId, GroupId
	MERGE [qan].[MATReviewDecisions] AS MRD
	USING (SELECT VersionId=@VersionId, MATReviewStageId=@StageId, MATReviewGroupId=@GroupId, MATReviewReviewerId=@ReviewerId, IsApproved=@Approved, Comment=@Comment) AS SRC
		ON (MRD.[VersionId]=@VersionId AND MRD.[ReviewStageId]=@StageId AND MRD.[ReviewGroupId]=@GroupId)
	WHEN NOT MATCHED THEN
		INSERT ([VersionId], [ReviewStageId], [ReviewGroupId], [ReviewReviewerId], [IsApproved], [Comment], [ReviewedOn]) 
		VALUES (SRC.[VersionId], SRC.[MATReviewStageId], SRC.[MATReviewGroupId], SRC.[MATReviewReviewerId], SRC.[IsApproved], SRC.[Comment], @On);

	DECLARE @StatusIdCheck int = 0;
	SELECT @StatusIdCheck=[StatusId] FROM [qan].[MATVersions] WITH (NOLOCK) WHERE [Id]=@VersionId

	IF (@StatusIdCheck != @Completed) BEGIN
		DECLARE @StageName varchar(50);
		DECLARE @GroupName varchar(50);
		SELECT @StageName=S.[StageName], @GroupName=G.[GroupName]
		FROM [qan].[MATReviewers] RR WITH (NOLOCK)
		INNER JOIN [qan].[MATReviewGroups] G WITH (NOLOCK) ON (G.[Id]=RR.[ReviewGroupId])
		INNER JOIN [qan].[MATReviewStages] S WITH (NOLOCK) ON (S.[Id]=RR.[ReviewStageId])
		WHERE RR.[Id]=@ReviewerId

		--If its not approved, its rejected.  Set status of the request to reflect this.
		--Also set the email template choice
		DECLARE @Audit varchar(100);
		DECLARE @emailTemplate varchar(50) = 'ReviewUpdateTemplate';
		IF (@Approved = 0) BEGIN
			--Set status of request to rejected
			UPDATE [qan].[MATVersions] SET [StatusId]=@Rejected WHERE [Id]=@VersionId
			SET @emailTemplate = 'ReviewRejectTemplate';
			--SELECT @Audit=('Request Rejected. Stage=' + @StageName + ', Group=' + @GroupName + ' Comment: ' + @Comment)
			--EXEC [qan].[CreateRequestChangeHistory] @RequestId, @Audit, @UserId
		END -- rejected
		ELSE BEGIN
			--Special case here.  If a reviewer has rejected a stage, and then a "parallel" stage reviewer has 
			--approved the stage (in this order), then were could be here and the request is actually in a reject
			--status.  Need to keep it in reject status.  First see if there are
			--any rejections in the Decisions table.  If there are, then keep the requests status at rejected.
			DECLARE @AnyRejects int = 0;
			SELECT @AnyRejects=COUNT([IsApproved]) FROM [qan].[MATReviewDecisions] WITH (NOLOCK)			
			WHERE [IsApproved]=0 AND [VersionId]=@VersionId
			
			IF (@AnyRejects > 0)
				UPDATE [qan].[MATVersions] SET [StatusId]=@Rejected WHERE [Id]=@VersionId
			ELSE
				-- If approved, then set status to "in review", this way it moves
				-- from Submitted to In Review.  You could check status first, but 
				-- its still an access of the db table.
				UPDATE [qan].[MATVersions] SET [StatusId]=@InReview WHERE [Id]=@VersionId

			--SELECT @Audit=('Request Approved. Stage=' + @StageName + ', Group=' + @GroupName + ' Comment: ' + @Comment)
			--EXEC [qan].[CreateRequestChangeHistory] @RequestId, @Audit, @UserId
		END -- approved
	END -- Request already completed

	-- This returns the Checklist Snap shot tables and then the Stage/Group/Reviewer snap shot tables
	EXEC [qan].[GetMATStagesAndReviewers] @VersionId

	-- This returns some fields for the Email subject line and text
	--SELECT R.Id AS RequestId, P.[Name] AS Product, R.TapeoutId, L.[Name] AS Layer, R.ReticleBarCode as 'BarCode'
	--	FROM [tc].[Requests] R 
	--	INNER JOIN [tc].[ProductLayers] PL (NOLOCK) ON (PL.Id=R.ProductLayersId)
	--	INNER JOIN [ref].[Products] P (NOLOCK) ON (P.Id=PL.ProductId)
	--	INNER JOIN [ref].[Layers] L (NOLOCK) ON (L.Id=R.LayersId)
	--	WHERE R.Id=@RequestId
	SELECT [Id], [VersionNumber]
	FROM [qan].[MATVersions]
	WHERE [Id]=@VersionId

	-- Return the Requestor name/email, and the template data for sending the emails.
	--SELECT RequestId=@RequestId, R.RequestedByEmail AS RequestorEmail, R.RequestedByName AS RequestorName,
	--E.TemplateName, E.TemplateText, E.TemplateDataFormat
	--FROM [tc].[Requests] R, [ref].[EmailTemplates] E
	--WHERE R.Id=@RequestId AND E.TemplateName=@emailTemplate;
	SELECT V.[Id], V.[CreatedBy], E.[Name], E.[Subject], X.[Value] AS [Body], E.[BodyXml] AS [Data]
	FROM [qan].[MATVersions] V WITH (NOLOCK), [ref].[EmailTemplates] AS E WITH (NOLOCK) INNER JOIN [ref].[EmailTemplateBodyXsls] AS X WITH (NOLOCK) ON (X.[Id] = E.[BodyXslId])
	WHERE V.[Id]=@VersionId AND E.[Name]=@emailTemplate;

	-- Also return the additional requestors email/names
	--SELECT RequestId=@RequestId, RR.email AS AdditionalRequestorEmail, RR.[name] AS AdditionalRequestorName
	--FROM [tc].[RequestRequestors] RR 
	--WHERE RR.RequestId=@RequestId

	--Now go see which reviewers need to get an email.  First find out the current stage
	--its possible there are two (for in parallel stages).  Then return the reviewers - there may be NONE.
	DECLARE @StageId1 int = 0;
	DECLARE @StageId2 int = 0;
	DECLARE @IsUpdate bit = 0; --Never an update from here.  See CreateRequest
	EXEC [qan].[GetMATCurrentStagesForEmailing] @VersionId, @UserId, @IsUpdate, @StageId1 OUTPUT, @StageId2 OUTPUT

	--Set the email template for the reviewers.  Depends on whether its rejected or not.
	IF (@Approved = 0) --rejected
		SET @emailTemplate = 'ReviewRejectReviewer';
	ELSE -- approved
		SET @emailTemplate = 'ReviewActionTemplate';
	
	--Send the email template for the reviewers.  Its either the default, set above, for when
	--the stage is approved and its time for the next stage.  Or the Reject template specific
	--for reviewers - different than the reject template for requestors
	--SELECT RequestId=@RequestId, E.TemplateName, E.TemplateText, E.TemplateDataFormat
	--FROM [ref].[EmailTemplates] E
	--WHERE E.TemplateName=@emailTemplate;
	SELECT @VersionId, E.[Name], E.[Subject], X.[Value] AS [Body], E.[BodyXml] AS [Data]
	FROM [ref].[EmailTemplates] AS E WITH (NOLOCK) INNER JOIN [ref].[EmailTemplateBodyXsls] AS X WITH (NOLOCK) ON (X.[Id] = E.[BodyXslId])
	WHERE E.[Name]=@emailTemplate; 

	--now return the reviewers that have work to do
	EXEC [qan].[GetMATReviewersWithWork] @VersionId, @StageId1, @StageId2, @UserId
END