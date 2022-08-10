-- ==================================================================
-- Author       : bricschx
-- Create date  : 2021-03-01 15:40:00.887
-- Description  : Gets an osat build criteria set
-- Example      : EXEC [qan].[GetOsatBuildCriteriaSet] 'bricschx', 1;
-- ==================================================================
CREATE PROCEDURE [qan].[GetOsatBuildCriteriaSet]
(
	  @UserId  VARCHAR(25)
	, @Id      BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;

	IF (@Id IS NULL) SET @Id = 0; -- if null, set to an invalid id so filters below will not match any records

	-- result set #1: build criteria set
	SELECT * FROM [qan].[FOsatBuildCriteriaSets](@Id, @UserId, NULL, NULL, NULL, NULL, NULL) ORDER BY [Id];

	-- result set #2: build criterias
	SELECT * FROM [qan].[FOsatBuildCriterias](NULL, @Id, NULL) ORDER BY [Ordinal], [Id];

	-- result set #3: build criteria conditions
	SELECT * FROM [qan].[FOsatBuildCriteriaConditions](NULL, @Id, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [AttributeTypeName], [ComparisonOperationName], [Id];

END
