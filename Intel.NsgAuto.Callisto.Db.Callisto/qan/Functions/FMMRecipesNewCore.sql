-- ==========================================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-21 19:02:04.520
-- Description  : Generates the core part of new MM recipes for the given PCodes
-- Example      : DECLARE @PCodes [qan].[IPCodes];
--                INSERT INTO @PCodes SELECT TOP 5 [PCode] FROM [CallistoCommon].[stage].[PCodes] WITH (NOLOCK) WHERE [IncludeMMRecipes] = 1;
--                SELECT * FROM [qan].[FMMRecipesNewCore](@PCodes);
-- ==========================================================================================================================================
CREATE FUNCTION [qan].[FMMRecipesNewCore]
(
	@PCodes [qan].[IPCodes] READONLY
)
RETURNS TABLE AS RETURN
(
	SELECT
		  CAST(0 AS BIT) AS [IsPOR]
		, CAST(1 AS BIT) AS [IsActive]
		, S.[Id] AS [StatusId]
		, S.[Name] AS [StatusName]
		, M.[PCode] AS [PCode]
		, M.[ProductName] AS [ProductName]
		, PF.[Id] AS [ProductFamilyId]
		, PF.[Name] AS [ProductFamilyName]
		, CAST(NULL AS INT) AS [MOQ] -- TODO
		, M.[ProductionProductCode]
		, M.[SCode] AS [SCode]
		, F.[Id] AS [FormFactorId]
		, F.[Name] AS [FormFactorName]
		, C.[Id] AS [CustomerId]
		, C.[Name] AS [CustomerName]
		, MM.[PRQDate] -- user input field
		, CQ.[Id] AS [CustomerQualStatusId] -- user input field
		, CQ.[Name] AS [CustomerQualStatusName]
		, M.[SCodeProductCode] AS [SCodeProductCode]
		, M.[ModelString] AS [ModelString]
		, PLC.[Id] AS [PLCStageId] -- user input field
		, PLC.[Name] AS [PLCStageName]
		, PL.[Id] AS [ProductLabelId]
	FROM [CallistoCommon].[stage].[SpeedMMRecipes] AS M WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[MMRecipes] AS MM WITH (NOLOCK) ON (MM.[PCode] = M.[PCode] AND MM.[IsPOR] = 1) -- needed to pre-populate user input fields
	LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) ON (S.[Name] = 'Draft')
	LEFT OUTER JOIN [qan].[ProductFamilies] AS PF WITH (NOLOCK) ON (M.[ProductFamily] = PF.[NameSpeed])
	LEFT OUTER JOIN [qan].[FormFactors] AS F WITH (NOLOCK) ON (M.[FormFactorName] = F.[NameSpeed])
	LEFT OUTER JOIN [qan].[Customers] AS C WITH (NOLOCK) ON (M.[CustomerName] = C.[NameSpeed])
	LEFT OUTER JOIN [ref].[CustomerQualStatuses] AS CQ WITH (NOLOCK) ON (CQ.[Id] = MM.[CustomerQualStatusId]) -- user input field
	LEFT OUTER JOIN [ref].[PLCStages] AS PLC WITH (NOLOCK) ON (PLC.[Id] = MM.[PLCStageId]) -- user input field
	LEFT OUTER JOIN [qan].[ProductLabelSetVersions] AS PLSV ON (PLSV.[IsPOR] = 1)
	LEFT OUTER JOIN [qan].[ProductLabels] AS PL WITH (NOLOCK) ON (PL.[ProductLabelSetVersionId] = PLSV.[Id] AND PL.[ProductionProductCode] = M.[ProductionProductCode])
	WHERE M.[PCode] IN (SELECT [PCode] FROM @PCodes)
)