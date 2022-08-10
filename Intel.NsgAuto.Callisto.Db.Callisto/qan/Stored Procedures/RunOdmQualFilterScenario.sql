-- =====================================================================================================
-- Author       : jkurianx
-- Create date  : 2021-05-19 17:23:50.767
-- Description  : Creates a new odm qual filter scenario and returns all result sets required by the UI
-- Example      : EXEC [qan].[RunOdmQualFilterScenario] 'jkurian';
-- =====================================================================================================
CREATE PROCEDURE [qan].[RunOdmQualFilterScenario]
(
	  @UserId        VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Id INT = NULL;

	EXEC [qan].[TaskCreateOdmQualFilterScenario] @Id OUTPUT, NULL, @UserId;

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
	FROM [qan].[OdmQualFilterScenarios] WITH (NOLOCK)
	WHERE [Id] = @Id
	ORDER BY [CreatedOn] DESC;

	-- all scenarion versions for the day (so that the drop down list is up to date)
	EXEC [qan].[GetOdmQualFilterScenarioVersionsDaily] @UserId;

END