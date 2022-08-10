
-- ==================================================================================================================================================
-- Author       : ftianx (modified based on [qan].[GetOdmQualFilterScenario])
-- Create date  : 2021-11-03 10:58:58.698
-- Description  : Get ODM Qual Filter Historical Scenario
-- Example      : EXEC [qan].[GetOdmQualFilterHistoricalScenario] 'fuhantx', 15
-- ==================================================================================================================================================

CREATE PROCEDURE [qan].[GetOdmQualFilterHistoricalScenario] 
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
	FROM [qan].[OdmQualFilterScenarios]
	WHERE [Id] = @Id

	EXEC [qan].[GetOdmQualFilterScenarioVersions] @UserId, @Id
	EXEC [qan].[GetOdmPrfVersionDetails] @UserId, @PrfVersion
	EXEC [qan].[GetOdmMatVersionDetails] @UserId, @MatVersion
	EXEC [qan].[GetOdmQualFilterNonQualifiedMediaReport] @UserId, @Id
	EXEC [qan].[GetOdmHistoricalComparisonLotDisposition] @UserId, @Id
	EXEC [qan].[GetOdmLotDispositionReasons] @UserId
	EXEC [qan].[GetOdmHistoricalQualFilterNonQualifiedMedia] @UserId, @Id
	EXEC [qan].[GetOdmHistoricalQualFilterNonQualifiedMediaExceptions] @UserId, @Id
	EXEC [qan].[GetOdmLotDispositionActions] @UserId
END