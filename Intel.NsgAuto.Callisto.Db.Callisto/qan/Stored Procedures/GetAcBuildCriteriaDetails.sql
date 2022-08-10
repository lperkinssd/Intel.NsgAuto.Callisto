-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-07 13:30:24.013
-- Description  : Gets all data needed for viewing the details for an auto checker build criteria.
-- Example      : EXEC [qan].[GetAcBuildCriteriaDetails] 'bricschx', 1;
-- ================================================================================================
CREATE PROCEDURE [qan].[GetAcBuildCriteriaDetails]
(
	  @UserId     VARCHAR(25)
	, @Id         BIGINT      = NULL
	, @IdCompare  BIGINT      = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @BuildCombinationId  INT;
	DECLARE @StatusId            INT;

	-- versions are grouped by build combination id
	SELECT @BuildCombinationId = MAX([BuildCombinationId]), @StatusId = MAX([StatusId]) FROM [AcBuildCriterias] WITH (NOLOCK) WHERE [Id] = @Id;

	IF (@IdCompare = 0) -- initial request and the value should be determined in this block
	BEGIN
		IF (@StatusId = 6) SET @IdCompare = NULL; -- Complete
		ELSE -- Draft, Canceled, Submitted, Rejected, In Review
		BEGIN
			-- choose the id for the most recent version in complete status
			SELECT @IdCompare = MAX([Id]) FROM [AcBuildCriterias] WITH (NOLOCK) WHERE [StatusId] = 6 AND [BuildCombinationId] = @BuildCombinationId AND [Id] < @Id;
		END;
	END
	ELSE IF (@IdCompare IS NOT NULL)
	BEGIN
		-- make sure @IdCompare has a valid value
		SELECT @IdCompare = MAX([Id]) FROM [AcBuildCriterias] WITH (NOLOCK) WHERE [BuildCombinationId] = @BuildCombinationId AND [Id] = @IdCompare;
	END;

	-- #1 result set: build criteria
	SELECT * FROM [qan].[FAcBuildCriterias](@Id, @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

	-- #2 result set: build criteria export conditions
	SELECT * FROM [qan].[FAcBuildCriteriaExportConditions](@UserId, NULL, NULL, @Id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [AttributeTypeName], [Id];

	-- #3 result set: build criteria comments
	SELECT * FROM [qan].[FAcBuildCriteriaComments](NULL, @Id) ORDER BY [Id] DESC;

	-- #4 result set: build criterias for comparison purposes
	SELECT * FROM [qan].[FAcBuildCriterias](NULL, @UserId, NULL, NULL, NULL, NULL, @BuildCombinationId, NULL, NULL, NULL, NULL, NULL, NULL) WHERE [Id] < @Id ORDER BY [Version] DESC, [Id] DESC;

	-- #5 result set: comparison results
	SELECT * FROM [qan].[FCompareAcBuildCriteriasByIds](@Id, @IdCompare) WHERE @IdCompare IS NOT NULL AND ([MissingFrom] IS NOT NULL OR [Different] = 1) ORDER BY [EntityType], [BuildCombinationId], [AttributeTypeId], [ComparisonOperationId];

	-- #6 result set: build criteria compared against
	SELECT * FROM [qan].[FAcBuildCriterias](@IdCompare, @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) WHERE @IdCompare IS NOT NULL;

	-- #7 result set: build criteria export conditions to compare against
	SELECT * FROM [qan].[FAcBuildCriteriaExportConditions](@UserId, NULL, NULL, @IdCompare, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) WHERE @IdCompare IS NOT NULL ORDER BY [AttributeTypeName], [Id];

	-- #8 result set: review stages
	SELECT * FROM [qan].[FAcBuildCriteriaReviewStages](NULL, @Id, NULL, NULL, NULL, NULL) ORDER BY [Sequence];

	-- #9 result set: review groups
	SELECT * FROM [qan].[FAcBuildCriteriaReviewGroups](NULL, @Id, NULL, NULL, NULL);

	-- #10 result set: reviewers
	SELECT * FROM [qan].[FAcBuildCriteriaReviewers](NULL, @Id, NULL, NULL, NULL, NULL, NULL, NULL);

	-- #11 result set: review decisions
	SELECT * FROM [qan].[FAcBuildCriteriaReviewDecisions](NULL, @Id, NULL, NULL, NULL, NULL);

END
