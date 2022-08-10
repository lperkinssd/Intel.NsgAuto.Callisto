
-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-21 12:09:21.415
-- Description:	Get Product Label version details
--         EXEC [qan].[GetProductLabelVersionDetails] 3, 'jakemurx'
-- =============================================
CREATE PROCEDURE [qan].[GetProductLabelVersionDetails] 
	-- Add the parameters for the stored procedure here
	@VersionId int, 
	@UserId varchar(50) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- Get the version details
	SELECT
		  V.[Id] AS 'VersionId'
		, V.[Version]
		, V.[IsActive]
		, V.[IsPOR]
		, V.[StatusId] AS [StatusId]
		, S.[Name] AS 'Status'
		, V.[CreatedBy]
		, V.[CreatedOn]
		, V.[UpdatedBy]
		, V.[UpdatedOn]
	FROM [qan].[ProductLabelSetVersions] AS V WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) ON (V.[StatusId] = S.[Id])
	WHERE V.[Id] = @VersionId

	-- Get the records in the specific Product Label version 
	SELECT
		  PL.[Id]
		, PL.[ProductionProductCode]
		, PF.[Id] AS [ProductFamilyId]
		, PF.[Name] AS [ProductFamilyName]
		, C.[Id] AS [CustomerId]
		, C.[Name] AS [CustomerName]
		, PFNS.[Id] AS [ProductFamilyNameSeriesId]
		, PFNS.[Name] AS [ProductFamilyNameSeriesName]
		, PL.[Capacity]
		, PL.[ModelString]
		, PL.[VoltageCurrent]
		, PL.[InterfaceSpeed]
		, OT.[Id] AS [OpalTypeId]
		, OT.[Name] AS [OpalTypeName]
		, PL.[KCCId]
		, PL.[CanadianStringClass]
		, PL.[CreatedBy]
		, PL.[CreatedOn]
		, PL.[UpdatedBy]
		, PL.[UpdatedOn]
	FROM [qan].[ProductLabels] PL WITH (NOLOCK)
	LEFT JOIN [qan].[ProductFamilies] PF WITH (NOLOCK) ON PL.[ProductFamilyId] = PF.[Id]
	LEFT JOIN [qan].[Customers] C WITH (NOLOCK) ON PL.[CustomerId] = C.[Id]
	LEFT JOIN [qan].[ProductFamilyNameSeries] PFNS WITH (NOLOCK) ON PL.[ProductFamilyNameSeriesId] = PFNS.[Id]
	LEFT JOIN [ref].[OpalTypes] OT WITH (NOLOCK) ON PL.[OpalTypeId] = OT.[Id]
	WHERE PL.[ProductLabelSetVersionId] = @VersionId

	-- Get attributes for each Product Label records
	SELECT 
		  A.Id
		, A.ProductLabelId
		, A.AttributeTypeId
		, T.[Name] AS [AttributeTypeName]
		, T.[NameDisplay] AS [AttributeTypeNameDisplay]
		, A.[Value]
		, A.[CreatedBy]
		, A.[CreatedOn]
		, A.[UpdatedBy]
		, A.[UpdatedOn]
	FROM [qan].[ProductLabels] PL WITH (NOLOCK)
		LEFT JOIN [qan].[ProductLabelAttributes] AS A WITH (NOLOCK)
			ON PL.Id = A.ProductLabelId
		INNER JOIN [ref].[ProductLabelAttributeTypes] AS T WITH (NOLOCK) 
			ON A.[AttributeTypeId] = T.[Id]
		WHERE PL.ProductLabelSetVersionId = @VersionId

	--If the version is in Draft state, , then just return no results.
	--There are no snapshot tables
	DECLARE @DraftStatusId int = (SELECT [Id] FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Draft')
	DECLARE @CancelStatusId int = (SELECT [Id] FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Canceled')

	DECLARE @CurrentStatusId int  = (SELECT [StatusId] FROM [qan].[ProductLabelSetVersions] WITH (NOLOCK) WHERE [Id] = @VersionId)
	IF (@CurrentStatusId IN (@DraftStatusId, @CancelStatusId))
		return;

	---- Get Reviews Steps

	---- Return the stages
	SELECT 
		  S.[Id] as [ReviewStageId]
		, S.[StageName]
		, S.[DisplayName] AS [StageDisplayName]
		, S.[ParentStageId] AS [ParentId]
		, ISNULL(S.[IsNextInParallel], 0) AS [IsNextInParallel] -- Make default as sequential approval stages
		, S.StageSequence
	FROM [qan].[ProductLabelReviewStages] S WITH (NOLOCK)
	WHERE S.[VersionId] = @VersionId
	ORDER BY S.StageSequence

	-- Return the groups
	SELECT G.[Id] AS [ReviewGroupId], G.[GroupName], G.[DisplayName] AS [GroupDisplayName], G.[ReviewStageId]
	FROM [qan].[ProductLabelReviewGroups] G WITH (NOLOCK)
	WHERE G.[VersionId] = @VersionId

	-- Return the Reviewers
	SELECT R.[Id] as [ReviewReviewerId], R.[ReviewStageId], R.[ReviewGroupId], R.[Idsid], R.[Wwid], R.[Name], R.[Email]
	FROM [qan].[ProductLabelReviewers] R WITH (NOLOCK)
	WHERE R.[VersionId] = @VersionId

	-- Return the decisions
	SELECT D.[ReviewStageId], D.[ReviewGroupId], D.[ReviewReviewerId], D.[IsApproved], D.[Comment], D.[ReviewedOn]
	FROM [qan].[ProductLabelReviewDecisions] D WITH (NOLOCK)
	WHERE D.[VersionId] = @VersionId

END