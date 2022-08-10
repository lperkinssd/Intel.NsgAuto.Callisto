


-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-20 15:13:33.321
-- Description:	Get MAT version details
--         EXEC [npsg].[GetMATVersionDetails] 'jakemurx', 11
-- =============================================
CREATE PROCEDURE [npsg].[GetMATVersionDetails] 	
	@VersionId int,
	@UserId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Get the version details
	SELECT
		  v.[Id] AS 'VersionId'
		, v.[VersionNumber]
		, v.[IsActive]
		, v.[StatusId]
		, LTRIM(RTRIM(s.[Name])) AS 'Status'
		, v.[IsPOR]
		, LTRIM(RTRIM(v.[CreatedBy])) AS [CreatedBy]
		, v.[CreatedOn]
		, LTRIM(RTRIM(v.[UpdatedBy])) AS [UpdatedBy]
		, v.[UpdatedOn]
	FROM [npsg].[MATVersions] v WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[Statuses] s WITH (NOLOCK) ON (v.[StatusId] = s.[Id])
	WHERE v.[Id] = @VersionId;

	-- Get the records in the specific the MAT version 
	--EXEC [npsg].[GetMATs] @UserId, null, @VersionId, true
	SELECT
		  m.[Id]
		, m.[MATVersionId]
		, v.[VersionNumber]
		, m.[SSDNameId]
		, LTRIM(RTRIM(ssd.[Name])) AS [SSDId]
		, p.[Id] AS [ProductId]
		, LTRIM(RTRIM(p.[Name])) AS [DesignId]
		--, pf.[Id] AS [ProductFamilyId]
		--, pf.[Name] AS [ProductFamilyName]
		, LTRIM(RTRIM(m.[SCode])) AS [SCode]
		, LTRIM(RTRIM(m.[MediaIPN])) AS [MediaIPN]
		, LTRIM(RTRIM(m.[MediaType])) AS [MediaType]
		, LTRIM(RTRIM(m.[DeviceName])) AS [DeviceName]
		, m.[CreatedBy] AS [CreatedBy]
		, m.[CreatedOn]
		, m.[UpdatedBy] AS [UpdatedBy]
		, m.[UpdatedOn]
	FROM [npsg].[MATs] m WITH (NOLOCK)
	INNER JOIN [npsg].[MATVersions] v
		ON m.[MATVersionId] = v.[Id]
	LEFT JOIN [npsg].[MATSSDNames] ssd WITH (NOLOCK)
		ON m.[SSDNameId] = ssd.[Id]
	LEFT JOIN [npsg].[Products] p WITH (NOLOCK)
		ON m.[ProductId] = p.[Id]
	WHERE m.[MATVersionId] = @VersionId
	ORDER BY m.[Id];

	-- Get attributes for each MAT records
	SELECT  mav.[Id]
		  , mav.[MATId]
		  , LTRIM(RTRIM(mt.[Name])) AS [Name]
		  , LTRIM(RTRIM(mt.[NameDisplay])) AS [NameDisplay]
		  , mav.[AttributeTypeId]
		  , LTRIM(RTRIM(mav.[Value])) AS [Value]
		  , LTRIM(RTRIM(mav.[Operator])) AS [Operator]
		  , LTRIM(RTRIM(mav.[DataType])) AS [DataType]
		  , mav.[CreatedBy] AS [CreatedBy]
		  , mav.[CreatedOn]
		  , mav.[UpdatedBy] AS [UpdatedBy]
		  , mav.[UpdatedOn]	
	FROM [npsg].[MATs] m WITH (NOLOCK)
		LEFT JOIN [npsg].[MATAttributeValues] mav WITH (NOLOCK)
			ON m.Id =  mav.[MATId]
		INNER JOIN [ref].[MATAttributeTypes] mt WITH (NOLOCK)
			ON mav.[AttributeTypeId] = mt.[Id]
	WHERE m.[MATVersionId] = @VersionId
	ORDER BY m.Id;
	
	---- Get ReviewsSteps
	--EXEC [npsg].[GetMATStagesAndReviewers] @VersionId

	--If the version is in Draft or Canceled state, , then just return no results.
	DECLARE @DraftStatusId int = (SELECT [Id] FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Draft')
	DECLARE @CancelStatusId int = (SELECT [Id] FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Canceled')

	DECLARE @CurrentStatusId int  = (SELECT [StatusId] FROM [npsg].[MATVersions] WITH (NOLOCK) WHERE [Id] = @VersionId)
	IF (@CurrentStatusId IN (@DraftStatusId, @CancelStatusId))
		return;

	------See if the Request already exists, if not create it first.
	----DECLARE @MATReviewStageId int;
	----SELECT @MATReviewStageId = [Id] FROM [npsg].[MATReviewStages] WITH (NOLOCK) WHERE [VersionId] = @VersionId
	----IF (@MATReviewStageId is null)
	----BEGIN
	----	EXEC [npsg].[CreateMATSnapShots] @VersionId
	----END

	-- Return the stages
	SELECT 
		  S.[Id] as [ReviewStageId]
		, S.[StageName]
		, S.[DisplayName] AS [StageDisplayName]
		, s.ParentStageId AS [ParentId]
		, ISNULL(s.[IsNextInParallel], 0) AS [IsNextInParallel] -- Make default as sequential approval stages
		, s.StageSequence
	FROM [npsg].[MATReviewStages] S WITH (NOLOCK)
	WHERE S.[VersionId] = @VersionId
	ORDER BY S.StageSequence

	-- Return the groups
	SELECT 
		  G.[Id] AS [ReviewGroupId]
		, G.[GroupName]
		, G.[DisplayName] AS [GroupDisplayName]
		, G.[ReviewStageId]
	FROM [npsg].[MATReviewGroups] G WITH (NOLOCK)
	WHERE G.[VersionId] = @VersionId

	-- Return the Reviewers
	SELECT 
		R.[Id] as [ReviewReviewerId]
		, R.[ReviewStageId]
		, R.[ReviewGroupId]
		, R.[Idsid]
		, R.[Wwid]
		, R.[Name]
		, R.[Email]
	FROM [npsg].[MATReviewers] R WITH (NOLOCK)
	WHERE R.[VersionId] = @VersionId

	-- Return the decisions
	SELECT 
		D.[ReviewStageId]
		, D.[ReviewGroupId]
		, D.[ReviewReviewerId]
		, D.[IsApproved]
		, D.[Comment]
		, D.[ReviewedOn]
	FROM [npsg].[MATReviewDecisions] D WITH (NOLOCK)
	WHERE D.[VersionId] = @VersionId


END