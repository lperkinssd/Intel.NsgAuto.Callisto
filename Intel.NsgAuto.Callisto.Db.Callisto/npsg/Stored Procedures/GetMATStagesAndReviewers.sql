


-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-09 16:09:45.521
-- Description:	Get stages and reviewers by versionId
--         EXEC [npsg].[GetMATStagesAndReviewers] 11
-- =============================================
CREATE PROCEDURE [npsg].[GetMATStagesAndReviewers] 
	-- Add the parameters for the stored procedure here
	@VersionId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--DECLARE @On DATETIME2(7) = GETUTCDATE();

	--If the bridge tables don't support a process yet, then just return no results.
	--DECLARE @GroupId int;
	--SELECT @GroupId=Id FROM [npsg].[ReviewStageReviewGroups] WHERE ProcessId=@ProcessId
	--IF (@GroupId is NULL)
	--	return;

	--If the version is in Draft state, , then just return no results.
	DECLARE @DraftStatusId int;
	SELECT @DraftStatusId = [Id] FROM [ref].[Statuses] WITH (NOLOCK) WHERE UPPER([Name]) = 'DRAFT'

	DECLARE @CurrentStatusId int;
	SELECT @CurrentStatusId = [StatusId] FROM [npsg].[MATVersions] WITH (NOLOCK) WHERE [Id] = @VersionId
	IF (@CurrentStatusId = @DraftStatusId)
		return;

	--See if the Request already exists, if not create it first.
	DECLARE @MATReviewStageId int;
	SELECT @MATReviewStageId = [Id] FROM [npsg].[MATReviewStages] WITH (NOLOCK) WHERE [VersionId] = @VersionId
	
	IF (@MATReviewStageId is null)
	BEGIN
		EXEC [npsg].[CreateMATSnapShots] @VersionId
	END

	--SELECT R.StageName, G.GroupName, CL.Id, CL.RequestReviewStageId, CL.RequestReviewGroupId, CL.RequestId, CL.IsCheckListCompleted
	--	FROM [tc].[RequestReviewCheckLists] CL
	--	INNER JOIN [ref].[ReviewStages] R (NOLOCK) ON (R.Id=CL.RequestReviewStageId)
	--	INNER JOIN [ref].[ReviewGroups] G (NOLOCK) ON (G.Id=CL.RequestReviewGroupId)
	--	WHERE CL.RequestId=@RequestId
	--	ORDER BY RequestReviewStageId, RequestReviewGroupId

	-- Return the stages
	SELECT S.[Id] as [ReviewStageId], S.[StageName], S.[DisplayName] AS [StageDisplayName]
	FROM [npsg].[MATReviewStages] S WITH (NOLOCK)
	WHERE S.[VersionId] = @VersionId
	--ORDER BY S.StageSequence

	-- Return the groups
	SELECT G.[Id] AS [ReviewGroupId], G.[GroupName], G.[DisplayName] AS [GroupDisplayName], G.[ReviewStageId]
	FROM [npsg].[MATReviewGroups] G WITH (NOLOCK)
	WHERE G.[VersionId] = @VersionId

	-- Return the Reviewers
	SELECT R.[Id] as [ReviewReviewerId], R.[ReviewStageId], R.[ReviewGroupId], R.[Idsid], R.[Wwid], R.[Name], R.[Email]
	FROM [npsg].[MATReviewers] R WITH (NOLOCK)
	WHERE R.[VersionId] = @VersionId

	-- Return the decisions
	SELECT D.[ReviewStageId], D.[ReviewGroupId], D.[ReviewReviewerId], D.[IsApproved], D.[Comment], D.[ReviewedOn]
	FROM [npsg].[MATReviewDecisions] D WITH (NOLOCK)
	WHERE D.[VersionId] = @VersionId
END