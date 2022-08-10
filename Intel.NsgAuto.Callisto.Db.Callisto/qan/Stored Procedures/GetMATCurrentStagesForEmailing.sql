
-- =============================================
-- Author       :	jakemurx
-- Create date  :	2020-10-16 09:49:28.359
-- Description	:	For the specified VersionId, figure out which stage should get 
--					any emails.  This SP uses the qan.MATReviewStageStates table
--					to remember the state of the emails.  It returns the stageId's 
--					that have emails to be sent.  Then these stageIds can be sent to the
--					[qan].[GetMATReviewersWithWork] stored proc to get the emails.  This
--					SP returns the StageId's via OUTPUT params.  The return values are
--					NULL if no stages found.
--					The @IsUpdate parameter indicates that an "Update" is being made
--					to the MAT version, not an approval/reject.  In the case of an update
--					the HasEmailSent state flag needs to be reset.  This is a special
--					case for when a request is being updated due to a reject.
--					This code was copied from Tapeout [tc].[GetCurrentStagesForEmailing] and
--					modified as necessary
--
--					EXEC [qan].[GetMATCurrentStagesForEmailing] @VersionId, @UserId, @IsUpdate, @StageId1 OUTPUT, @StageId2 OUTPUT
--
-- =============================================
CREATE PROCEDURE [qan].[GetMATCurrentStagesForEmailing] 
	-- Add the parameters for the stored procedure here
	@VersionId int,
	@UserId [varchar](255),
	@IsUpdate bit,
	@StageId1 int OUTPUT,
	@StageId2 int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--IF OBJECT_ID('tempdb..#TopTemp') IS NOT NULL
 --   DROP TABLE #TopTemp

	--For this request, get the list of Stage, Groups, Reviewers, Decisions
	SELECT S.[Id] AS [SID], S.[StageName], S.[StageSequence],
	G.[Id] AS GID, G.[GroupName], R.[Id] AS [RID], R.[Idsid], R.[Name], R.[Wwid], R.[Email], D.[IsApproved]
	INTO #TopTemp
	FROM [qan].[MATReviewStages] S WITH (NOLOCK)
	INNER JOIN [qan].[MATReviewGroups] G WITH (NOLOCK) ON (G.[ReviewStageId]=S.[Id] AND G.[VersionId]=S.[VersionId])
	INNER JOIN [qan].[MATReviewers] R WITH (NOLOCK) ON (R.[ReviewGroupId]=G.[Id] AND R.[ReviewStageId]=S.[Id] AND R.[VersionId]=S.[VersionId])
	LEFT OUTER JOIN [qan].[MATReviewDecisions] D WITH (NOLOCK) ON (D.[ReviewReviewerId]=R.[Id] AND D.[ReviewGroupId]=G.[Id] AND D.[ReviewStageId]=S.[Id] AND D.[VersionId]=S.[VersionId])
	WHERE S.[VersionId]=@VersionId 

	--IF OBJECT_ID('tempdb..#LEVEL2') IS NOT NULL
 --   DROP TABLE #LEVEL2

	--Calculate the Num Approvals, Num Rejections
	SELECT [SID], [StageName], [StageSequence], [GroupName], 
	SUM( Case WHEN [IsApproved] = 1 THEN 1 ELSE 0 END) AS [NumAppr],
	SUM( Case WHEN [IsApproved] = 0 THEN 1 ELSE 0 END) AS [NumRej]
	INTO #LEVEL2
	FROM #TopTemp
	GROUP BY [SID], [GID], [StageName], [StageSequence], [GroupName]

	--IF OBJECT_ID('tempdb..#LEVEL3') IS NOT NULL
 --   DROP TABLE #LEVEL3

	--Now calculate the status of stage (Done or NOT Done), and pull in the state
	--from the [tc].[RequestReviewStageStates] table
	SELECT [SID], [StageName], [StageSequence],
	COUNT(StageName) AS [NumGroups], SUM([NumAppr]) AS [TotalAppr], SUM([NumRej]) AS [TotalRej],
	CASE WHEN COUNT([StageName])=SUM([NumAppr]) THEN 'Done' ELSE 'NOT Done' END AS [Status]
	, S.[IsActive], S.[HasEmailSent], S.[HasBeenRejected]
	INTO #LEVEL3
	FROM #LEVEL2
	LEFT JOIN [qan].[MATReviewStageStates] S WITH (NOLOCK) ON (S.[VersionId]=@VersionId AND S.[ReviewStageId]=[SID])
	GROUP BY [SID], [StageName], [StageSequence], S.[IsActive], S.[HasEmailSent], S.[HasBeenRejected]

	--SELECT * FROM #LEVEL3

	--Get the first one that is NOT DONE, use the minimum StageSequence
	DECLARE @MinSeq int = 0;
	DECLARE @StageSequence int = 0;
	SELECT @MinSeq=MIN([StageSequence]) FROM #LEVEL3 WHERE [Status] != 'Done'

	--SELECT @MinSeq AS 'MinSeq'

	--If you found one, start here
	IF (@MinSeq > 0) BEGIN
		--print 'Something is not done.  Sequence=' + CAST( @MinSeq AS varchar(10))
	
		DECLARE @SID int = null;
		DECLARE @IsActive bit = 0;
		DECLARE @IsParallel bit = 0;
		DECLARE @TotalRejected int = 0;
		DECLARE @Status varchar(20);
		DECLARE @HasBeenRej bit = 0;

		--Get the first row found 
		SELECT @IsActive=[IsActive], @SID=[SID], @TotalRejected=[TotalRej]
		FROM #LEVEL3 WHERE [StageSequence]=@MinSeq
	
		-- When an update occurs, emails need to be sent.  Use the incoming parameter to determine.  Update once you get the SID
		IF (@IsUpdate = 1) BEGIN
			UPDATE [qan].[MATReviewStageStates] 
			SET [HasEmailSent]=0 
			WHERE [VersionId]=@VersionId 
			AND [ReviewStageId]=@SID
		END

		--See if the first NOT DONE is active, if not then set it to active
		IF (@IsActive IS NULL OR  @IsActive != 1) BEGIN
			--print 'SID[' + CAST( @SID AS varchar(10)) + '] was not active, setting now'
			INSERT INTO [qan].[MATReviewStageStates] 
			([VersionId], [ReviewStageId], [IsActive], [HasEmailSent]) 
			VALUES (@VersionId, @SID, 1, 0)
		END
		--ELSE
		--	print 'SID[' + CAST( @SID AS varchar(10)) + '] was already active, no need to set it '

		--Is it rejected?  If so, reset hasEmail flag
		IF (@TotalRejected > 0) BEGIN
			SELECT @HasBeenRej=[HasBeenRejected] 
			FROM [qan].[MATReviewStageStates] WITH (NOLOCK) 
			WHERE [VersionId]=@VersionId 
			AND [ReviewStageId]=@SID

			IF (@HasBeenRej IS NULL OR @HasBeenRej = 0) BEGIN
				--print 'SID[' + CAST( @SID AS varchar(10)) + '] was rejected, reset HasEmailSent flag '
				UPDATE [qan].[MATReviewStageStates]  
				SET [HasEmailSent]=0, 
					[HasBeenRejected]=1 
				WHERE [VersionId]=@VersionId 
				AND [ReviewStageId]=@SID
			END
			--ELSE
			--	print 'SID[' + CAST( @SID AS varchar(10)) + '] was rejected, already set HasEmailSent flag '
		END
		ELSE BEGIN
			--print 'not rejected';
			UPDATE [qan].[MATReviewStageStates] 
			SET [HasBeenRejected]=0 
			WHERE [VersionId]=@VersionId 
			AND [ReviewStageId]=@SID
		END	
	END --If there is any not done

	--IF OBJECT_ID('tempdb..#LEVEL33') IS NOT NULL
	--DROP TABLE #LEVEL33

	--Now we need to refresh the table, changes may have occurred above.
	SELECT [SID], [StageName], [StageSequence], 
	COUNT([StageName]) AS [NumGroups], SUM([NumAppr]) AS [TotalAppr], SUM([NumRej]) AS [TotalRej],
	CASE WHEN COUNT([StageName])=SUM([NumAppr]) THEN 'Done' ELSE 'NOT Done' END AS [Status]
	, S.[IsActive], S.[HasEmailSent], S.[HasBeenRejected]
	INTO #LEVEL33
	FROM #LEVEL2
	LEFT JOIN [qan].[MATReviewStageStates] S WITH (NOLOCK) ON (S.[VersionId]=@VersionId AND S.[ReviewStageId]=[SID])
	GROUP BY [SID], [StageName], [StageSequence], S.[IsActive], S.[HasEmailSent], S.[HasBeenRejected]

	--SELECT * FROM #LEVEL33

	--IF OBJECT_ID('tempdb..#FinalTemp') IS NOT NULL
	--DROP TABLE #FinalTemp

	--Here is where we set the OUTPUT StageIds.  Get any SIDs that are active and no Email sent yet
	--Just set the variables and they are automatically returned.
	--Since i may have two StageId's, i need to set them both.  So i select into a temp table and then pull each
	--row using the StageSequence.
	SET @StageId1 = NULL;
	SET @StageId2 = NULL;
	SELECT [SID], [StageSequence] 
	INTO #FinalTemp 
	FROM #Level33 
	WHERE Status != 'Done' AND [IsActive]=1 AND [HasEmailSent] != 1

	--SELECT * FROM #FinalTemp

	SELECT @MinSeq=MIN([StageSequence]) FROM #FinalTemp
	IF (@MinSeq IS NOT NULL) BEGIN
		SELECT @StageId1=[SID] FROM #FinalTemp WHERE [StageSequence]=@MinSeq	--Get the first StageId
		DELETE #FinalTemp WHERE [StageSequence]=@MinSeq						--Delete that row from temp table
		SELECT @MinSeq=MIN([StageSequence]) FROM #FinalTemp					--Get the next min StageSequence if there is another
		IF (@MinSeq IS NOT NULL) BEGIN
			SELECT @StageId2=[SID] FROM #FinalTemp WHERE [StageSequence]=@MinSeq	--Get the second StageId
		END
	END

	--Last step is to update the [MATReviewStageStates] table
	UPDATE [qan].[MATReviewStageStates]
	SET [HasEmailSent]=1
	WHERE [ReviewStageId] IN (SELECT [SID] AS [ReviewStageId] FROM #Level33 WHERE [Status] != 'Done' AND [IsActive]=1 AND [HasEmailSent] != 1) 
	AND [VersionId]=@VersionId


END