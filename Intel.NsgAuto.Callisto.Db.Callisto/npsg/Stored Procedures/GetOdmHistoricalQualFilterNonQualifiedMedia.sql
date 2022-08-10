

-- ==================================================================================================================================================
-- Author       : ftianx (modified based on [npsg].[GetOdmHistoricalQualFilterNonQualifiedMedia])
-- Create date  : 2021-11-03 10:58:58.698
-- Description  : Get raw Odm Qual Filter Historical Non Qualified Media
-- Revise date  : 2022-06-16 (add WIP filter to be consistent with daily)
-- Example      : EXEC [npsg].[GetOdmHistoricalQualFilterNonQualifiedMedia] 'fuhantx', 15
-- ==================================================================================================================================================

CREATE PROCEDURE [npsg].[GetOdmHistoricalQualFilterNonQualifiedMedia] 
	@UserId varchar(25), 
	@Id int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @nonQualified INT = (SELECT Id FROM [ref].[OdmQualFilterCategories] WITH (NOLOCK) WHERE [Name] = 'Non Qualified')
	DECLARE @OdmWipSnapshotVersion INT = (SELECT [OdmWipSnapshotVersion] FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE [Id] = @Id)

	;WITH LatestSLotUpdateTimeStamps AS
	(
		SELECT DISTINCT
			nqm.SLot, 
			MAX(ows.time_entered) AS [MaxTimeEntered]
		FROM [npsg].[OdmQualFiltersHistory] nqm WITH (NOLOCK)
			INNER JOIN [npsg].[OdmWipSnapshotsHistory] ows WITH (NOLOCK)
				ON nqm.SLot = ows.media_lot_id
		WHERE nqm.[ScenarioId] = @Id
		AND ows.[Version] = @OdmWipSnapshotVersion
		GROUP BY nqm.SLot
	)

	SELECT qf.[Id]
		  ,qf.[ScenarioId]
		  ,qf.[OdmId]
		  ,o.[Name] AS [OdmName]
		  ,qf.[SCode] AS [MMNum]
		  ,qf.[MediaIPN] AS [OsatIpn]
		  ,qf.[SLot]
		  ,qf.OdmQualFilterCategoryId AS [CategoryId]
		  ,qfc.[Name] AS [CategoryName]
	FROM [npsg].[OdmQualFiltersHistory] qf
		INNER JOIN [npsg].[OdmWipSnapshotsHistory] ows WITH (NOLOCK)
			ON qf.SLot = ows.media_lot_id
			AND ows.Version = @OdmWipSnapshotVersion
		INNER JOIN LatestSLotUpdateTimeStamps ts  WITH (NOLOCK)
			ON ows.media_lot_id = ts.SLot
			AND ows.time_entered = ts.MaxTimeEntered
		INNER JOIN [ref].[Odms] o 
			ON qf.OdmId = o.Id
			AND ows.[subcon_name] = o.[Name]
		INNER JOIN [ref].[OdmQualFilterCategories] qfc ON qf.OdmQualFilterCategoryId = qfc.Id
	WHERE [ScenarioId] = @Id
	AND qf.OdmQualFilterCategoryId = @nonQualified
	ORDER BY qf.[OdmId] ASC, qf.[SCode] ASC, qf.[MediaIPN] ASC, qf.[SLot] ASC;
	
END