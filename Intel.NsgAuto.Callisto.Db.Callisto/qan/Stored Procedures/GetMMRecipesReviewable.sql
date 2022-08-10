

-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-29 14:25:54.184
-- Description:	Get MM Recipes in Draft, Submitted, or In Review status
-- =============================================
CREATE PROCEDURE [qan].[GetMMRecipesReviewable] 
	-- Add the parameters for the stored procedure here
	  @UserId VARCHAR(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Draft int, @Submitted int, @InReview int
	SELECT @Draft = 1, @Submitted = 3, @InReview = 5
			
	-- Insert statements for procedure here
	SELECT
		  M.[Id]
		, M.[Version]
		, M.[IsPOR]
		, M.[IsActive]
		, M.[StatusId]
		, S.[Name] AS [StatusName]
		, M.[CreatedBy]
		, M.[CreatedOn]
		, M.[UpdatedBy]
		, M.[UpdatedOn]
		, M.[PCode]
		, M.[ProductName]
		, M.[ProductFamilyId]
		, PF.[Name] AS [ProductFamilyName]
		, M.[MOQ]
		, M.[ProductionProductCode]
		, M.[SCode]
		, M.[FormFactorId]
		, F.[Name] AS [FormFactorName]
		, M.[CustomerId]
		, C.[Name] AS [CustomerName]
		, M.[PRQDate]
		, M.[CustomerQualStatusId]
		, CQ.[Name] AS [CustomerQualStatusName]
		, M.[SCodeProductCode]
		, M.[ModelString]
		, M.[PLCStageId]
		, PL.[Name] AS [PLCStageName]
		, M.[ProductLabelId]
		, L.[Capacity] AS [ProductLabelCapacity]
	FROM [qan].[MMRecipes] AS M WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) ON (M.[StatusId] = S.[Id])
	LEFT OUTER JOIN [qan].[ProductFamilies] AS PF WITH (NOLOCK) ON (M.[ProductFamilyId] = PF.[Id])
	LEFT OUTER JOIN [qan].[FormFactors] AS F WITH (NOLOCK) ON (M.[FormFactorId] = F.[Id])
	LEFT OUTER JOIN [qan].[Customers] AS C WITH (NOLOCK) ON (M.[CustomerId] = C.[Id])
	LEFT OUTER JOIN [ref].[CustomerQualStatuses] AS CQ WITH (NOLOCK) ON (M.[CustomerQualStatusId] = CQ.[Id])
	LEFT OUTER JOIN [ref].[PLCStages] AS PL WITH (NOLOCK) ON (M.[PLCStageId] = PL.[Id])
	LEFT OUTER JOIN [qan].[ProductLabels] AS L WITH (NOLOCK) ON (M.[ProductLabelId] = L.[Id])
	WHERE M.[StatusId] = @Draft OR M.[StatusId] = @Submitted OR M.[StatusId] = @InReview;
END