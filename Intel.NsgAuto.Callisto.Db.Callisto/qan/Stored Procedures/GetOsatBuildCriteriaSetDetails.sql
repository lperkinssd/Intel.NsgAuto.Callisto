-- ===========================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-01 16:49:01.423
-- Description  : Gets all data needed for viewing the details for an osat build criteria set.
-- Example      : EXEC [qan].[GetOsatBuildCriteriaSetDetails] 'bricschx', 1;
-- ===========================================================================================
CREATE PROCEDURE [qan].[GetOsatBuildCriteriaSetDetails]
(
	  @UserId     VARCHAR(25)
	, @Id         BIGINT = NULL
	, @IdCompare  BIGINT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @BuildCombinationId  INT;
	DECLARE @StatusId            INT;

	IF (@Id IS NULL) SET @Id = 0; -- set to an invalid id so function filters below will work properly

	-- versions are grouped by build combination id
	SELECT @BuildCombinationId = MAX([BuildCombinationId]), @StatusId = MAX([StatusId]) FROM [OsatBuildCriteriaSets] WITH (NOLOCK) WHERE [Id] = @Id;

	IF (@IdCompare = 0) -- initial request and the value should be determined in this block
	BEGIN
		IF (@StatusId = 6) SET @IdCompare = NULL; -- Complete
		ELSE -- Draft, Canceled, Submitted, Rejected, In Review
		BEGIN
			-- choose the id for the most recent version in complete status
			SELECT @IdCompare = MAX([Id]) FROM [OsatBuildCriteriaSets] WITH (NOLOCK) WHERE [StatusId] = 6 AND [BuildCombinationId] = @BuildCombinationId AND [Id] < @Id;
		END;
	END
	ELSE IF (@IdCompare IS NOT NULL)
	BEGIN
		-- make sure @IdCompare has a valid value
		SELECT @IdCompare = MAX([Id]) FROM [OsatBuildCriteriaSets] WITH (NOLOCK) WHERE [BuildCombinationId] = @BuildCombinationId AND [Id] = @IdCompare;
	END;

	-- #1 result set: build criteria sets
	SELECT * FROM [qan].[FOsatBuildCriteriaSets](@Id, @UserId, NULL, NULL, NULL, NULL, NULL);

	-- #2 result set: build criterias
	SELECT * FROM [qan].[FOsatBuildCriterias](NULL, @Id, NULL) ORDER BY [Ordinal], [Id];

	-- #3 result set: build criteria conditions
	SELECT * FROM [qan].[FOsatBuildCriteriaConditions](NULL, @Id, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [AttributeTypeName], [Id];

	-- #4 result set: build criteria set comments
	SELECT * FROM [qan].[FOsatBuildCriteriaSetComments](NULL, @Id) ORDER BY [Id] DESC;

	-- #5 result set: build criteria sets for comparison purposes
	SELECT * FROM [qan].[FOsatBuildCriteriaSets](NULL, @UserId, NULL, NULL, NULL, NULL, @BuildCombinationId) WHERE [Id] < @Id ORDER BY [Version] DESC, [Id] DESC;

	-- #6 result set: comparison results
	SELECT * FROM [qan].[FCompareOsatBuildCriteriaSetsByIds](@Id, @IdCompare) WHERE @IdCompare IS NOT NULL AND ([MissingFrom] IS NOT NULL OR [Different] = 1) ORDER BY [EntityType], [BuildCombinationId], [AttributeTypeId], [ComparisonOperationId];

	-- #7 result set: build criteria set compared against
	SELECT * FROM [qan].[FOsatBuildCriteriaSets](@IdCompare, @UserId, NULL, NULL, NULL, NULL, NULL) WHERE @IdCompare IS NOT NULL;

	-- #8 result set: build criterias compared against
	SELECT * FROM [qan].[FOsatBuildCriterias](NULL, @IdCompare, NULL) ORDER BY [Ordinal], [Id];

	-- #9 result set: build criteria conditions compared against
	SELECT * FROM [qan].[FOsatBuildCriteriaConditions](NULL, @IdCompare, NULL, NULL, NULL, NULL, NULL, NULL) WHERE @IdCompare IS NOT NULL ORDER BY [AttributeTypeName], [Id];

	-- #10 result set: review stages
	SELECT * FROM [qan].[FOsatBuildCriteriaSetReviewStages](NULL, @Id, NULL, NULL, NULL, NULL) ORDER BY [Sequence];

	-- #11 result set: review groups
	SELECT * FROM [qan].[FOsatBuildCriteriaSetReviewGroups](NULL, @Id, NULL, NULL, NULL);

	-- #12 result set: reviewers
	SELECT * FROM [qan].[FOsatBuildCriteriaSetReviewers](NULL, @Id, NULL, NULL, NULL, NULL, NULL, NULL);

	-- #13 result set: review decisions
	SELECT * FROM [qan].[FOsatBuildCriteriaSetReviewDecisions](NULL, @Id, NULL, NULL, NULL, NULL);

END
