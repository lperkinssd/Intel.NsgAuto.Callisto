
-- ==================================================================================================================================================
-- Author       : ftianx (modified based on [npsg].[GetOdmQualFilterScenario])
-- Create date  : 2021-11-03 10:58:58.698
-- Description  : Get ODM Qual Filter Historical Scenario
-- Example      : EXEC [npsg].[GetOdmQualFilterHistoricalScenario] 'fuhantx', 15
-- ==================================================================================================================================================

CREATE PROCEDURE [npsg].[GetOdmQualFilterHistoricalScenario] 
	@UserId VARCHAR(25), 
	@Id INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PrfVersion INT,
			@MatVersion INT,
			@OdmWipSnapshotVersion INT,
			@LotShipSnapshotVersion INT,
			@LotDispositionSnapshotVersion INT

	SELECT
		 @PrfVersion = [PrfVersion]
		,@MatVersion = [MatVersion]
		,@OdmWipSnapshotVersion = [OdmWipSnapshotVersion]
		,@LotShipSnapshotVersion = [LotShipSnapshotVersion]
		,@LotDispositionSnapshotVersion = [LotDispositionSnapshotVersion]
	FROM [npsg].[OdmQualFilterScenarios]
	WHERE [Id] = @Id

	EXEC [npsg].[GetOdmQualFilterScenarioVersions] @UserId, @Id
	EXEC [npsg].[GetOdmPrfVersionDetails] @UserId, @PrfVersion
	EXEC [npsg].[GetOdmMatVersionDetails] @UserId, @MatVersion
	EXEC [npsg].[GetOdmQualFilterNonQualifiedMediaReport] @UserId, @Id
	EXEC [npsg].[GetOdmHistoricalComparisonLotDisposition] @UserId, @Id
	EXEC [npsg].[GetOdmLotDispositionReasons] @UserId
	EXEC [npsg].[GetOdmHistoricalQualFilterNonQualifiedMedia] @UserId, @Id
	EXEC [npsg].[GetOdmHistoricalQualFilterNonQualifiedMediaExceptions] @UserId, @Id
	EXEC [npsg].[GetOdmLotDispositionActions] @UserId
END