

-- ==================================================================================================================================================
-- Author       : ftianx (modified based on [qan].[GetOdmHistoricalQualFilterNonQualifiedMedia])
-- Create date  : 2021-11-03 10:58:58.698
-- Description  : Get raw Odm Qual Filter Historical Non Qualified Media
-- Example      : EXEC [qan].[GetOdmHistoricalQualFilterNonQualifiedMedia] 'fuhantx', 15
-- ==================================================================================================================================================

CREATE PROCEDURE [qan].[GetOdmHistoricalQualFilterNonQualifiedMedia] 
	@UserId varchar(25), 
	@Id int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @nonQualified INT = (SELECT Id FROM [ref].[OdmQualFilterCategories] WITH (NOLOCK) WHERE [Name] = 'Non Qualified')

	SELECT qf.[Id]
		  ,qf.[ScenarioId]
		  ,qf.[OdmId]
		  ,o.[Name] AS [OdmName]
		  ,qf.[SCode] AS [MMNum]
		  ,qf.[MediaIPN] AS [OsatIpn]
		  ,qf.[SLot]
		  ,qf.OdmQualFilterCategoryId AS [CategoryId]
		  ,qfc.[Name] AS [CategoryName]
	FROM [qan].[OdmQualFiltersHistory] qf
	INNER JOIN [ref].[Odms] o ON qf.OdmId = o.Id
	INNER JOIN [ref].[OdmQualFilterCategories] qfc ON qf.OdmQualFilterCategoryId = qfc.Id
	WHERE [ScenarioId] = @Id
	AND qf.OdmQualFilterCategoryId = @nonQualified
	ORDER BY qf.[OdmId] ASC, qf.[SCode] ASC, qf.[MediaIPN] ASC, qf.[SLot] ASC;

END