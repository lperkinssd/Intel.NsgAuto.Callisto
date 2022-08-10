-- ============================================================================
-- Author       : bricschx
-- Create date  : 2020-10-12 17:52:20.490
-- Description  : Gets mm recipes
-- Example      : SELECT * FROM [qan].[FMMRecipes](1, NULL, NULL, NULL, NULL);
-- ============================================================================
CREATE FUNCTION [qan].[FMMRecipes]
(
	  @Id BIGINT = NULL
	, @PCode VARCHAR(10) = NULL
	, @Version INT = NULL
	, @IsActive BIT = NULL
	, @IsPOR BIT = NULL
)
RETURNS TABLE AS RETURN
(
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
		, PLC.[Name] AS [PLCStageName]
		, M.[ProductLabelId]
		, PL.[Capacity] AS [ProductLabelCapacity]
		, M.[SubmittedBy]
		, M.[SubmittedOn]
	FROM [qan].[MMRecipes] AS M WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) ON (S.[Id] = M.[StatusId])
	LEFT OUTER JOIN [qan].[ProductFamilies] AS PF WITH (NOLOCK) ON (PF.[Id] = M.[ProductFamilyId])
	LEFT OUTER JOIN [qan].[FormFactors] AS F WITH (NOLOCK) ON (F.[Id] = M.[FormFactorId])
	LEFT OUTER JOIN [qan].[Customers] AS C WITH (NOLOCK) ON (C.[Id] = M.[CustomerId])
	LEFT OUTER JOIN [ref].[CustomerQualStatuses] AS CQ WITH (NOLOCK) ON (CQ.[Id] = M.[CustomerQualStatusId])
	LEFT OUTER JOIN [ref].[PLCStages] AS PLC WITH (NOLOCK) ON (PLC.[Id] = M.[PLCStageId])
	LEFT OUTER JOIN [qan].[ProductLabels] AS PL WITH (NOLOCK) ON (PL.[Id] = M.[ProductLabelId])
	WHERE (@Id IS NULL OR M.[Id] = @Id)
	  AND (@PCode IS NULL OR M.[PCode] = @PCode)
	  AND (@Version IS NULL OR M.[Version] = @Version)
	  AND (@IsActive IS NULL OR M.[IsActive] = @IsActive)
	  AND (@IsPOR IS NULL OR M.[IsPOR] = @IsPOR)
)
