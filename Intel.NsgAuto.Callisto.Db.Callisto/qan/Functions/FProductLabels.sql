-- ===============================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-12 12:20:30.373
-- Description  : Gets product labels
-- Example      : SELECT * FROM [qan].[FProductLabels](1, NULL);
-- ===============================================================================================
CREATE FUNCTION [qan].[FProductLabels]
(
	  @Id BIGINT = NULL
	, @SetVersionId INT = NULL
)
RETURNS TABLE AS RETURN
(
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
	WHERE (@Id IS NULL OR PL.[Id] = @Id) AND (@SetVersionId IS NULL OR PL.[ProductLabelSetVersionId] = @SetVersionId)
)
