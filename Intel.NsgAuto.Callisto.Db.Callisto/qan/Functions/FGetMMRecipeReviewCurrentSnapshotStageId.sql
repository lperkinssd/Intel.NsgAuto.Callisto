-- ===========================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-21 13:14:08.543
-- Description  : Returns the mm recipe review current snapshot stage id
-- Example      : SELECT [qan].[FGetMMRecipeReviewCurrentSnapshotStageId](1);
-- ===========================================================================================
CREATE FUNCTION [qan].[FGetMMRecipeReviewCurrentSnapshotStageId](@VersionId BIGINT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @Result BIGINT;

	SELECT TOP 1 @Result = [Id] FROM [qan].[MMRecipeReviewStages] WITH (NOLOCK) WHERE [VersionId] = @VersionId AND [ReviewStageId] IN
	(
		SELECT [ReviewStageId] FROM
		(
			-- innermost query gets all review stage and group combinations that do not have any decisions
			SELECT DISTINCT [ReviewStageId], [ReviewGroupId] FROM [qan].[MMRecipeReviewGroups] WITH (NOLOCK) WHERE [VersionId] = @VersionId
			EXCEPT
			SELECT DISTINCT [ReviewStageId], [ReviewGroupId] FROM [qan].[MMRecipeReviewDecisions] WITH (NOLOCK) WHERE [VersionId] = @VersionId
		) AS T
	)
	ORDER BY [Sequence] ASC, [Id] ASC;

	RETURN @Result;
END
