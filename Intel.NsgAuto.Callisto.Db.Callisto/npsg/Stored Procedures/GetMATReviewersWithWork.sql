
-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-15 14:21:01.740
-- Description:	returns the "active" reviewers for a given request and stages
--				EXEC [npsg].[GetMATReviewersWithWork] @VersionId, @StageId, @StageId2, @UserId
--				Its possible to send in two stages, in the case of parallel stages
--				StageId2 is the second stage, and if its null, then no second stage.
--				This coed was copied from Tapeout [tc].[GetReviewersWithWork]
--				
--				EXEC [npsg].[GetMATReviewersWithWork] @VersionId, @StageId, @StageId2, @UserId
--
-- =============================================
CREATE PROCEDURE [npsg].[GetMATReviewersWithWork] 
	-- Add the parameters for the stored procedure here
	@VersionId int,
	@StageId int,
	@StageId2 int,
	@UserId [varchar](255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--Get the reviewers for the given RequestId and StageId
	SELECT G.[Id] AS [GID], G.[GroupName], R.[Id] AS [RID], D.[IsApproved]
	INTO #Temp1
	FROM [npsg].[MATReviewStages] S WITH (NOLOCK)
	INNER JOIN [npsg].[MATReviewGroups] G WITH (NOLOCK) ON (G.[ReviewStageId]=S.[Id] AND G.[VersionId]=S.[VersionId])
	INNER JOIN [npsg].[MATReviewers] R WITH (NOLOCK) ON (R.[ReviewGroupId]=G.[Id] AND R.[ReviewStageId]=S.[Id] AND R.[VersionId]=S.[VersionId])
	LEFT OUTER JOIN [npsg].[MATReviewDecisions] D WITH (NOLOCK) ON (D.[ReviewReviewerId]=R.[Id] AND D.[ReviewGroupId]=G.[Id] AND D.[ReviewStageId]=S.[Id] AND D.[VersionId]=S.[VersionId])
	WHERE S.[VersionId]=@VersionId AND S.[Id]=@StageId

	--Figure out which group has approved.  If anyone in group approved, entire group has approved
	SELECT [GID],
	SUM( Case WHEN [IsApproved] = 1 THEN 1 ELSE 0 END) AS [TotalApproved],
	COUNT(RID) as [TotalReviewers]
	INTO #Temp2
	FROM #Temp1
	GROUP BY [GroupName], [GID]

	--Get "Distinct" reviewers from the groups that have NO approvals.  Distinct because a reviewer may
	--be in multiple groups, don't need to send them more than one email.
	SELECT DISTINCT(R.[Name]) AS [ReviewerName], R.[Email] AS [ReviewerEmail], @VersionId AS [VersionId]
	INTO #Reviewers1
	FROM [npsg].[MATReviewStages] S WITH (NOLOCK)
	INNER JOIN [npsg].[MATReviewGroups] G WITH (NOLOCK) ON (G.[ReviewStageId]=S.[Id] AND G.[VersionId]=S.[VersionId])
	INNER JOIN [npsg].[MATReviewers] R WITH (NOLOCK) ON (R.[ReviewGroupId]=G.[Id] AND R.[ReviewStageId]=S.[Id] AND R.[VersionId]=S.[VersionId])
	WHERE S.[VersionId]=@VersionId AND S.[Id]=@StageId AND G.[Id] IN (SELECT [GID] AS [Id] FROM #Temp2 WHERE [TotalApproved]=0)

	-- If there is another stage (@StageId2) then get the reviewers for that stage too.
	-- Make sure they are not already approved.
	-- Merge the results into the #Reviewer1 temp table
	IF (@StageId2 IS NOT NULL) BEGIN
		--Get the reviewers for the given RequestId and second StageId
		SELECT G.[Id] AS [GID], G.[GroupName], R.[Id] AS [RID], D.[IsApproved]
		INTO #Temp10
		FROM [npsg].[MATReviewStages] S WITH (NOLOCK)
		INNER JOIN [npsg].[MATReviewGroups] G WITH (NOLOCK) ON (G.[ReviewStageId]=S.[Id] AND G.[VersionId]=S.[VersionId])
		INNER JOIN [npsg].[MATReviewers] R WITH (NOLOCK) ON (R.[ReviewGroupId]=G.[Id] AND R.[ReviewStageId]=S.[Id] AND R.[VersionId]=S.[VersionId])
		LEFT OUTER JOIN [npsg].[MATReviewDecisions] D WITH (NOLOCK) ON (D.[ReviewReviewerId]=R.[Id] AND D.[ReviewGroupId]=G.[Id] AND D.[ReviewStageId]=S.[Id] AND D.[VersionId]=S.[VersionId])
		WHERE S.[VersionId]=@VersionId AND S.Id=@StageId2

		--Figure out which group has approved.  If anyone in group approved, entire group has approved
		select GID,
		SUM( Case WHEN IsApproved = 1 THEN 1 ELSE 0 END) AS [TotalApproved],
		COUNT(RID) AS [TotalReviewers]
		INTO #Temp20
		FROM #Temp10
		GROUP BY [GroupName], [GID]

		--Get "Distinct" reviewers from the groups that have NO approvals.  Distinct because a reviewer may
		--be in multiple groups, don't need to send them more than one email.
		SELECT DISTINCT(R.[Name]) AS [ReviewerName], R.[Email] AS [ReviewerEmail], @VersionId AS [VersionId]
		INTO #Reviewers10
		FROM [npsg].[MATReviewStages] S 
		INNER JOIN [npsg].[MATReviewGroups] G WITH (NOLOCK) ON (G.[ReviewStageId]=S.[Id] AND G.[VersionId]=S.[VersionId])
		INNER JOIN [npsg].[MATReviewers] R WITH (NOLOCK) ON (R.[ReviewGroupId]=G.[Id] AND R.[ReviewStageId]=S.[Id] AND R.[VersionId]=S.[VersionId])
		WHERE S.[VersionId]=@VersionId AND S.Id=@StageId2 AND G.Id IN (SELECT [GID] AS [Id] FROM #Temp20 WHERE [TotalApproved]=0)

		--Merge the results into the existing Reviewers table
		MERGE INTO #Reviewers1 TRG
		USING #Reviewers10 SRC ON (TRG.[ReviewerName]=SRC.[ReviewerName])
		WHEN NOT MATCHED THEN
		INSERT ([ReviewerName], [ReviewerEmail], [VersionId])
		VALUES (SRC.[ReviewerName], SRC.[ReviewerEmail], @VersionId);
	END

	--Return the reviewers
	SELECT [ReviewerName], [ReviewerEmail], [VersionId]
	FROM #Reviewers1

END