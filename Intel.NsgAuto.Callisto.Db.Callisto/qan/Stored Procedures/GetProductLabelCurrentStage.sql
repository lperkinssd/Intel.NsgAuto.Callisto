

-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-22 16:59:44.427
-- Description:	Get Product Label current unfinished stage
--         EXEC 
-- =============================================
CREATE PROCEDURE [qan].[GetProductLabelCurrentStage] 
	-- Add the parameters for the stored procedure here
	@VersionId int,
	@UserId [varchar](255),
	@StageId int OUTPUT,
	@StageName varchar(50) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @StageId = 0;  --default value;
	SET @StageName = 'All Stages Complete';  --default value
		
	SELECT S.Id AS [SID]
		 , S.StageName
		 , G.Id AS GID
		 , G.GroupName
		 , R.Id AS RID
		 , R.Idsid
		 , R.Name
		 , R.Wwid
		 , R.Email
		 , D.IsApproved
	INTO #TopTemp
	FROM [qan].[ProductLabelReviewStages] S WITH (NOLOCK)
	INNER JOIN [qan].[ProductLabelReviewGroups] G WITH (NOLOCK) ON G.[ReviewStageId] = S.[Id] AND G.[VersionId] = S.[VersionId]
	INNER JOIN [qan].[ProductLabelReviewers] R WITH (NOLOCK) ON R.[ReviewGroupId] = G.[Id] AND R.[ReviewStageId] = S.[Id] AND R.[VersionId] = S.[VersionId]
	LEFT OUTER JOIN [qan].[ProductLabelReviewDecisions] D WITH (NOLOCK) ON D.[ReviewReviewerId] = R.[Id] AND D.[ReviewGroupId]=G.[Id] AND D.[ReviewStageId]=S.[Id] AND D.[VersionId]=S.[VersionId]
	WHERE S.[VersionId] = @VersionId

	--Calculate the Num Approvals, Num Rejections
	SELECT [SID]
		 , [StageName]
		 , [GroupName]
		 , SUM( Case WHEN [IsApproved] = 1 THEN 1 ELSE 0 END) as [NumAppr]
		 , SUM( Case WHEN [IsApproved] = 0 THEN 1 ELSE 0 END) as [NumRej]
	INTO #LEVEL2
	FROM #TopTemp
	GROUP BY [SID], [GID], [StageName], [GroupName]

	--Now calculate the status of the stages (Done or NOT Done)
	SELECT [SID]
		 , [StageName]
		 , COUNT([StageName]) as [NumGroups]
		 , SUM([NumAppr]) as [TotalAppr]
		 , SUM([NumRej]) as [TotalRej]
		 , CASE WHEN COUNT([StageName])=SUM([NumAppr]) THEN 'Done' ELSE 'NOT Done' END AS [Status]
	INTO #LEVEL3
	FROM #LEVEL2
	GROUP by [SID], [StageName]

	--Get the first not done stage
	DECLARE @MinId int = 0;
	SELECT @MinId=min([SID]) FROM #LEVEL3 WHERE [Status] != 'Done'

	--Get the stage name and ID.  If its one of the child steps then return
	--the parent stage name.
	SELECT [SID] AS [StageId]
		 , [StageName]
	INTO #Final
	FROM #LEVEL3 WHERE [SID]=@MinId

	--Return the StageId and StageName
	SELECT @StageId=[StageId], @StageName=[StageName] FROM #Final
END