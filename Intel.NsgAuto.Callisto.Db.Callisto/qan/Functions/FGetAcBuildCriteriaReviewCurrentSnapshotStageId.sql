-- ===========================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-10 13:07:48.617
-- Description  : Returns the auto checker build criteria review current snapshot stage id
-- Example      : SELECT [qan].[FGetAcBuildCriteriaReviewCurrentSnapshotStageId](1);
-- ===========================================================================================
CREATE FUNCTION [qan].[FGetAcBuildCriteriaReviewCurrentSnapshotStageId](@VersionId BIGINT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @Result BIGINT;

	SELECT TOP 1 @Result = [Id] FROM [qan].[AcBuildCriteriaReviewStages] WITH (NOLOCK) WHERE [VersionId] = @VersionId AND [ReviewStageId] IN
	(
		SELECT [ReviewStageId] FROM
		(
			-- innermost query gets all review stage and group combinations that do not have any decisions
			SELECT DISTINCT [ReviewStageId], [ReviewGroupId] FROM [qan].[AcBuildCriteriaReviewGroups] WITH (NOLOCK) WHERE [VersionId] = @VersionId
			EXCEPT
			SELECT DISTINCT [ReviewStageId], [ReviewGroupId] FROM [qan].[AcBuildCriteriaReviewDecisions] WITH (NOLOCK) WHERE [VersionId] = @VersionId
		) AS T
	)
	ORDER BY [Sequence] ASC, [Id] ASC;

	RETURN @Result;
END
