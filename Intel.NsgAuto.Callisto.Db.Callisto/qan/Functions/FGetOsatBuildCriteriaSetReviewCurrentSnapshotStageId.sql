-- ===========================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-29 15:44:25.493
-- Description  : Returns the osat build criteria set review current snapshot stage id
-- Example      : SELECT [qan].[FGetOsatBuildCriteriaSetReviewCurrentSnapshotStageId](1);
-- ===========================================================================================
CREATE FUNCTION [qan].[FGetOsatBuildCriteriaSetReviewCurrentSnapshotStageId](@VersionId BIGINT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @Result BIGINT;

	SELECT TOP 1 @Result = [Id] FROM [qan].[OsatBuildCriteriaSetReviewStages] WITH (NOLOCK) WHERE [VersionId] = @VersionId AND [ReviewStageId] IN
	(
		SELECT [ReviewStageId] FROM
		(
			-- innermost query gets all review stage and group combinations that do not have any decisions
			SELECT DISTINCT [ReviewStageId], [ReviewGroupId] FROM [qan].[OsatBuildCriteriaSetReviewGroups] WITH (NOLOCK) WHERE [VersionId] = @VersionId
			EXCEPT
			SELECT DISTINCT [ReviewStageId], [ReviewGroupId] FROM [qan].[OsatBuildCriteriaSetReviewDecisions] WITH (NOLOCK) WHERE [VersionId] = @VersionId
		) AS T
	)
	ORDER BY [Sequence] ASC, [Id] ASC;

	RETURN @Result;
END
