




-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-22 16:57:06.211
-- Description:	Create Product Label Snapshots
-- =============================================
CREATE PROCEDURE [qan].[CreateProductLabelSnapshots] 
	-- Add the parameters for the stored procedure here
	@VersionId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Check to see if the snapshot tables already exist 
	DECLARE @StageVersion int
	SELECT @StageVersion = [VersionId] FROM [qan].[ProductLabelReviewStages] WHERE [VersionId] = @VersionId

	IF @StageVersion IS NOT NULL
		RETURN;

	-- First get the Stages based on IsActive
	SELECT RTRS.[Id] AS [ReviewTypeReviewStageId]
		 , RTRS.[ReviewStageId]
		 , RS.[StageName]
		 , RS.[DisplayName]
		 , RS.[Sequence] AS [StageSequence]
		 , RS.[ParentStageId]
		 , ISNULL(RS.[IsNextInParallel], 0) AS [IsNextInParallel] -- Make default as sequential approval stages
	INTO #TempStages
	FROM [qan].[ReviewTypeReviewStages] RTRS WITH (NOLOCK)
	INNER JOIN [qan].[ReviewStages] RS WITH (NOLOCK) ON (RS.Id=RTRS.ReviewStageId)
	WHERE RTRS.ReviewTypeId = (SELECT [Id] FROM [ref].[ReviewTypes] WITH (NOLOCK) WHERE [Description] = 'Product Label Version')
	AND RS.[IsActive] = 1

	-- Insert them into the ProductLabelReviewStages table
	INSERT INTO [qan].[ProductLabelReviewStages]
		( [Id]
		, [VersionId]
		, [StageName]
		, [DisplayName]
		, [StageSequence]
		, [ParentStageId]
		, [IsNextInParallel]
		)
	SELECT [ReviewStageId]
		, @VersionId
		, [StageName]
		, [DisplayName]
		, [StageSequence]
		, [ParentStageId]
		, [IsNextInParallel]
	FROM #TempStages

	-- Now get the Groups for these Stages.  Use the stageIds from the #TempStages table
	SELECT RSRG.[Id] AS ReviewStageReviewGroupId
		 , RTRS.[ReviewStageId]
		 , RSRG.[ReviewGroupId]
		 , G.[GroupName]
		 , G.[DisplayName]
	INTO #TempGroups
	FROM [qan].[ReviewStageReviewGroups] RSRG WITH (NOLOCK)
	INNER JOIN [qan].[ReviewTypeReviewStages] RTRS WITH (NOLOCK) ON (RTRS.[Id]=RSRG.[ReviewTypeReviewStageId])
	INNER JOIN [qan].[ReviewGroups] G WITH (NOLOCK) ON (G.Id=RSRG.ReviewGroupId)
	WHERE RSRG.[ReviewTypeReviewStageId] in (SELECT [ReviewTypeReviewStageId] FROM #TempStages) 
	AND G.IsActive=1 

	-- Insert them into the ProductLabelReviewGroups table
	INSERT INTO [qan].[ProductLabelReviewGroups]
		( [Id]
		, [VersionId]
		, [ReviewStageId]
		, [GroupName]
		, [DisplayName])
	SELECT [ReviewGroupId]
		, @VersionId
		, [ReviewStageId]
		, [GroupName]
		, [DisplayName]
	FROM #TempGroups

	-- Now get the Reviewers.  Join with the #TempGroups table in order to get the ReviewGroupReviewerId
	SELECT RTRS.[ReviewStageId]
		 , RSRG.[ReviewGroupId]
		 , G.[GroupName]
		 , RGR.[ReviewerId]
		 , R.[Name]
		 , R.[Idsid]
		 , R.[Wwid]
		 , R.[Email]
	INTO #TempReviewers
	FROM [qan].[ReviewGroupReviewers] RGR WITH (NOLOCK)
	INNER JOIN [qan].[ReviewStageReviewGroups] RSRG WITH (NOLOCK) 
		ON (RSRG.[Id]=RGR.[ReviewStageReviewGroupId])
	INNER JOIN [qan].[ReviewTypeReviewStages] RTRS WITH (NOLOCK) 
		ON (RTRS.[Id]=RSRG.[ReviewTypeReviewStageId])
	INNER JOIN [qan].[ReviewGroups] G WITH (NOLOCK) 
		ON (G.[Id]=RSRG.[ReviewGroupId])
	INNER JOIN [qan].[Reviewers] R WITH (NOLOCK) 
		ON (R.[Id]=RGR.[ReviewerId])
	WHERE RGR.[ReviewStageReviewGroupId] IN (SELECT [ReviewStageReviewGroupId] FROM #TempGroups)

	-- And insert them into the ProductLabelReviewers table.
	INSERT INTO [qan].[ProductLabelReviewers]
		( [VersionId]
		, [ReviewStageId]
		, [ReviewGroupId]
		, [Name]
		, [Idsid]
		, [Wwid]
		, [Email])
	SELECT @VersionId
		, [ReviewStageId]
		, [ReviewGroupId]
		, [Name]
		, [Idsid]
		, [Wwid]
		, [Email]
	FROM #TempReviewers
END