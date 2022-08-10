-- =====================================================================================================
-- Author       : jkurianx
-- Create date  : 2021-05-19 17:23:50.767
-- Description  : Creates a new odm qual filter scenario and returns all result sets required by the UI
-- Example      : EXEC [npsg].[RunOdmQualFilterScenario] 'jkurian';
-- =====================================================================================================
CREATE PROCEDURE [npsg].[RunOdmQualFilterScenario]
(
	  @UserId        VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Id INT = NULL;

	EXEC [npsg].[TaskCreateOdmQualFilterScenario] @Id OUTPUT, NULL, @UserId;

	SELECT 
		  [Id]
		, [PrfVersion]
		, [MatVersion]
		, [OdmWipSnapshotVersion]
		, [LotShipSnapshotVersion]
		, [LotDispositionSnapshotVersion]
		, [DailyId]
		, [StatusId]
		, [CreatedBy]
		, [CreatedOn]
	FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK)
	WHERE [Id] = @Id
	ORDER BY [CreatedOn] DESC;

	-- all scenarion versions for the day (so that the drop down list is up to date)
	EXEC [npsg].[GetOdmQualFilterScenarioVersionsDaily] @UserId;

END