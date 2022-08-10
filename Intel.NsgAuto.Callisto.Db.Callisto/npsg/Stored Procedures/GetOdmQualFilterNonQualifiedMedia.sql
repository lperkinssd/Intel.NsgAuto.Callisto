



-- =============================================
-- Author:		jakemurx
-- Create date: 2021-03-19 08:46:51.073
-- Description:	Get raw Odm Qual Filter Non Qualified Media
-- EXEC [npsg].[GetOdmQualFilterNonQualifiedMedia] 'jakemurx', 60
-- =============================================
CREATE PROCEDURE [npsg].[GetOdmQualFilterNonQualifiedMedia] 
	-- Add the parameters for the stored procedure here
	@UserId varchar(25), 
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @OdmWipSnapshotVersion INT = (SELECT [OdmWipSnapshotVersion] FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE [Id] = @Id)

	;WITH LatestSLotUpdateTimeStamps AS
	(
		SELECT DISTINCT
			nqm.SLot, 
			MAX(ows.time_entered) AS [MaxTimeEntered]
		FROM [npsg].[OdmQualFilters] nqm WITH (NOLOCK)
			INNER JOIN [npsg].[OdmWipSnapshots] ows WITH (NOLOCK)
				ON nqm.SLot = ows.media_lot_id
		WHERE nqm.[ScenarioId] = @Id
		AND ows.[Version] = @OdmWipSnapshotVersion
		GROUP BY nqm.SLot
	)

    -- Insert statements for procedure here
	SELECT qf.[Id]
		  ,qf.[ScenarioId]
		  ,qf.[OdmId]
		  ,o.[Name] AS [OdmName]
		  ,qf.[SCode] AS [MMNum]
		  ,qf.[MediaIPN] AS [OsatIpn]
		  ,qf.[SLot]
		  ,qf.OdmQualFilterCategoryId AS [CategoryId]
		  ,qfc.[Name] AS [CategoryName]
	FROM [npsg].[OdmQualFilters] qf
		INNER JOIN [npsg].[OdmWipSnapshots] ows WITH (NOLOCK)
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
	AND qf.OdmQualFilterCategoryId = 1 --Not Qualified
	ORDER BY qf.[OdmId] ASC, qf.[SCode] ASC, qf.[MediaIPN] ASC, qf.[SLot] ASC;

END