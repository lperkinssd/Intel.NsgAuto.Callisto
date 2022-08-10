
-- ==================================================================================================================================================
-- Author       : ftianx
-- Create date  : 2021-11-03 10:58:58.698
-- Description  : Get ODM Qual Filter Historical Scenarios
-- Example      : EXEC [qan].[GetOdmQualFilterScenarioHistoricalVersions] 'fuhantx'
 -- ==================================================================================================================================================
CREATE PROCEDURE [qan].[GetOdmQualFilterScenarioHistoricalVersions]
	  @UserId VARCHAR(25)
	, @Id INT = NULL
	, @PrfVersion INT = NULL
	, @MatVersion INT = NULL
	, @OdmWipSnapshotVersion INT = NULL
	, @LotShipSnapshotVersion INT = NULL
	, @LotDispositionSnapshotVersion INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @latestScenarioId INT = (SELECT MAX(Id) FROM [qan].[OdmQualFilterScenarios] WITH (NOLOCK))
	DECLARE @latestScenarioCreatedOn DATETIME2(7) = (SELECT CreatedOn FROM [qan].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE Id = @latestScenarioId)
	DECLARE @latestScenarioDate DATETIME2(7) = DATEADD(DD, DATEDIFF(DD, 0, @latestScenarioCreatedOn), 0)

	SELECT [Id]
		,[PrfVersion]
		,[MatVersion]
		,[OdmWipSnapshotVersion]
		,[LotShipSnapshotVersion]
		,[LotDispositionSnapshotVersion]
		,[DailyId]
		,[StatusId]
		,[CreatedOn]
		,[CreatedBy]
	FROM [qan].[OdmQualFilterScenarios]
	WHERE (@Id IS NULL OR [Id] = @Id)
	  AND (@PrfVersion IS NULL OR [PrfVersion] = @PrfVersion)
	  AND (@MatVersion IS NULL OR [MatVersion] = @MatVersion)
	  AND (@OdmWipSnapshotVersion IS NULL OR [OdmWipSnapshotVersion] = @OdmWipSnapshotVersion)
	  AND (@LotShipSnapshotVersion IS NULL OR [LotShipSnapshotVersion] = @LotShipSnapshotVersion)
	  AND (@LotDispositionSnapshotVersion IS NULL OR [LotDispositionSnapshotVersion] = @LotDispositionSnapshotVersion)
	  AND CreatedOn < @latestScenarioDate
	ORDER BY [Id] DESC
END