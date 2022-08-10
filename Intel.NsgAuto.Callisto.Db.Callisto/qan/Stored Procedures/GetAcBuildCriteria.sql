-- =============================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 11:13:38.503
-- Description  : Gets an auto checker build criteria
-- Example      : EXEC [qan].[GetAcBuildCriteria] 'bricschx', 1;
-- =============================================================
CREATE PROCEDURE [qan].[GetAcBuildCriteria]
(
	  @UserId  VARCHAR(25)
	, @Id      BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;

	-- record set #1: build criteria
	SELECT * FROM [qan].[FAcBuildCriterias](@Id, @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [Id];

	-- record set #2: build criteria conditions
	SELECT * FROM [qan].[FAcBuildCriteriaExportConditions](@UserId, NULL, NULL, @Id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [AttributeTypeName], [Id];

END
