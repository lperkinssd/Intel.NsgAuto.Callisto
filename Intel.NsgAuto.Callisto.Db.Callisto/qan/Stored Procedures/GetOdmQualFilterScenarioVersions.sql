
-- =============================================
-- Author:		jakemurx
-- Create date: 2021-02-25 13:44:48.807
-- Description:	Get ODM Qual Filter Scenarios
-- EXEC [qan].[GetOdmQualFilterScenarioVersions] 'jakemurx'
-- EXEC [qan].[GetOdmQualFilterScenarioVersions] 'jakemurx', 60
-- EXEC [qan].[GetOdmQualFilterScenarioVersions] 'jakemurx', null, 1
-- EXEC [qan].[GetOdmQualFilterScenarioVersions] 'jakemurx', null, null, 2
-- EXEC [qan].[GetOdmQualFilterScenarioVersions] 'jakemurx', null, null, null, 30
-- EXEC [qan].[GetOdmQualFilterScenarioVersions] 'jakemurx', null, null, null, null, 22
-- EXEC [qan].[GetOdmQualFilterScenarioVersions] 'jakemurx', null, null, null, null, null, null
-- EXEC [qan].[GetOdmQualFilterScenarioVersions] 'jakemurx', null, null, null, null, null, null, 3
-- EXEC [qan].[GetOdmQualFilterScenarioVersions] 'jakemurx', null, null, null, null, null, null, null, 1
-- =============================================
CREATE PROCEDURE [qan].[GetOdmQualFilterScenarioVersions] 
	-- Add the parameters for the stored procedure here
	  @UserId VARCHAR(25)
	, @Id INT = NULL
	, @PrfVersion INT = NULL
	, @MatVersion INT = NULL
	, @OdmWipSnapshotVersion INT = NULL
	, @LotShipSnapshotVersion INT = NULL
	, @LotDispositionSnapshotVersion INT = NULL
	, @DailyId INT = NULL
	, @StatusId INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
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
	  AND (@DailyId IS NULL OR [DailyId] = @DailyId)
	  AND (@StatusId IS NULL OR [StatusId] = @StatusId)
	ORDER BY [Id] DESC
END