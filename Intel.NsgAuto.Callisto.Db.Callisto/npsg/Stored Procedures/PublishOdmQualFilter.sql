



-- =============================================
-- Author:		jkurian
-- Create date: 2021-04-27 16:02:49.163
-- Description:	Get the Odm Qual Filter Scenario that is published
-- =============================================
CREATE PROCEDURE [npsg].[PublishOdmQualFilter]
	-- Add the parameters for the stored procedure here
	@UserId varchar(25),
	@ScenarioId int          = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- If Scenario id is null, then publish the latest scenario
	IF @ScenarioId IS NULL
	BEGIN
		SET @ScenarioId = (SELECT MAX(Id) FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK));
	END

    DECLARE @ScenarioDate DateTime2(7) = (SELECT [CreatedOn] FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE Id = @ScenarioId);
	DECLARE @OdmWipSnapshotVersion INT = (SELECT [OdmWipSnapshotVersion] FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE [Id] = @ScenarioId)

	;WITH LatestSLotUpdateTimeStamps AS
	(
		SELECT DISTINCT
			nqm.SLot, 
			MAX(ows.time_entered) AS [MaxTimeEntered]
		FROM [npsg].[OdmQualFilters] nqm WITH (NOLOCK)
			INNER JOIN [npsg].[OdmWipSnapshots] ows WITH (NOLOCK)
				ON nqm.SLot = ows.media_lot_id
		WHERE nqm.[ScenarioId] = @ScenarioId
		AND ows.[Version] = @OdmWipSnapshotVersion
		GROUP BY nqm.SLot
	)

	SELECT 	
        oqf.[SCode]			AS [MMNum]
	  , o.[Name]			AS [OdmName]
	  ,	oqf.[DesignId]		AS [DesignId]
      ,	oqf.[MediaIPN]		AS [OsatIpn]
      ,	oqf.[SLot]			AS [SLots]
      , @ScenarioDate		AS [CreatedOn]
	FROM [npsg].[OdmQualFilters] oqf WITH (NOLOCK)
		INNER JOIN [npsg].[OdmWipSnapshots] ows WITH (NOLOCK)
			ON oqf.SLot = ows.media_lot_id
			AND ows.Version = @OdmWipSnapshotVersion
		INNER JOIN LatestSLotUpdateTimeStamps ts  WITH (NOLOCK)
			ON ows.media_lot_id = ts.SLot
			AND ows.time_entered = ts.MaxTimeEntered
		INNER JOIN [ref].[Odms] o WITH (NOLOCK)
			ON oqf.[OdmId] = o.[Id]
			AND ows.[subcon_name] = o.[Name]
	WHERE oqf.[ScenarioId] = @ScenarioId
	AND oqf.OdmQualFilterCategoryId = 1; -- Non Qualified

	-- Return all exceptions
	EXEC [npsg].[GetOdmQualFilterNonQualifiedMediaExceptions] @UserId, @ScenarioId

	-- Return all Odm Names
	EXEC [npsg].[GetOdms] @UserId

	UPDATE [npsg].[OdmQualFilterScenarios]
	SET [StatusId] = 3
	WHERE [Id] = @ScenarioId;

END