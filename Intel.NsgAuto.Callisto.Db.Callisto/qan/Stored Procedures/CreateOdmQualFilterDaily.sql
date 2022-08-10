



-- =============================================================
-- Author		: jakemurx
-- Create date	: 2021-04-20 09:05:20.010
-- Description	: Create new ODM Qual Filter records for this scenarioId
-- EXEC [qan].[CreateOdmQualFilter] 'jakemurx', 1
-- =============================================================
CREATE PROCEDURE [qan].[CreateOdmQualFilterDaily]
(
	  @UserId varchar(50),
	  @CountInserted INT = NULL OUTPUT
)
 AS
 BEGIN

	DECLARE @Id INT = (SELECT TOP 1 [Id] FROM [qan].[OdmQualFilterScenarios] ORDER BY [Id] DESC);
	DECLARE @Count INT = (SELECT COUNT(*) FROM [qan].[OdmQualFilters] WITH (NOLOCK) WHERE [ScenarioId] = @Id)

	SET @CountInserted = 0;

	-- Exit becuse there is already non-qualified media for the latest scenario and nothing has changed since it was created
	IF @Count > 0
		RETURN;

	EXEC [qan].[CreateOdmQualFilters] @Id, @UserId

	SELECT @CountInserted = COUNT(*) FROM [qan].[OdmQualFilters] WHERE [ScenarioId] = @Id;

 END