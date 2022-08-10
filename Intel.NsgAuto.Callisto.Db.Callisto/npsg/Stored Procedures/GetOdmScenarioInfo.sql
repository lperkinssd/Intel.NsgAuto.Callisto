
-- ==================================================================================================================================================
-- Author       : ftianx
-- Create date  : 2022-01-25 13:45:03.288
-- Description  : Get the data version and load time info for a scenario
-- Example      : DECLARE @scenarioId = 15
--                DECLARE @userId VARCHAR(50) = 'ftianx';
--                
--                EXEC [npsg].[GetOdmScenarioInfo] @userId,  @scenarioId 
-- ==================================================================================================================================================
CREATE PROCEDURE [npsg].[GetOdmScenarioInfo]
(
	@userId               VARCHAR(50)
	, @scenarioId         INT
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PrfVersion INT,
			@MatVersion INT,
			@OdmWipSnapshotVersion INT,
			@LotShipSnapshotVersion INT

	SELECT
		 @PrfVersion = [PrfVersion]
		,@MatVersion = [MatVersion]
		,@OdmWipSnapshotVersion = [OdmWipSnapshotVersion]
		,@LotShipSnapshotVersion = [LotShipSnapshotVersion]
	FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK)
	WHERE [Id] = @scenarioId

	DECLARE @latestLotshipLoadTime datetime2(7) = (SELECT MIN([CreatedOn]) FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE [LotShipSnapshotVersion] = @LotShipSnapshotVersion)
	DECLARE @latestWipLoadTime datetime2(7) = (SELECT MIN([CreatedOn]) FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE [OdmWipSnapshotVersion] = @OdmWipSnapshotVersion)
	DECLARE @latestMatImportTime datetime2(7) = (SELECT MAX([CreatedOn]) FROM [npsg].[MAT] WITH (NOLOCK) WHERE [MatVersion] = @MatVersion)
	DECLARE @latestPrfImportTime datetime2(7) = (SELECT MIN([CreatedOn]) FROM [npsg].[PRFDCR] WITH (NOLOCK) WHERE [PrfVersion] = @PrfVersion)

	SELECT @LotShipSnapshotVersion AS LotShipVersion
		,@latestLotshipLoadTime AS LotshipLoadTime
		,@OdmWipSnapshotVersion AS WipVersion
		,@latestWipLoadTime AS WipLoadTime
		,@MatVersion AS MatVersion
		,@latestMatImportTime AS MatImportTime
		,@PrfVersion AS PrfVersion
		,@latestPrfImportTime AS PrfImportTime

END