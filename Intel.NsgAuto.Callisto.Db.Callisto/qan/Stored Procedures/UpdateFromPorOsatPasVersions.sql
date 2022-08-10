-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-04-28 15:44:35.900
-- Description  : Updates the system from current por osat pas versions
-- Example      : EXEC [qan].[UpdateFromPorOsatPasVersions];
-- =======================================================================
CREATE PROCEDURE [qan].[UpdateFromPorOsatPasVersions]
(
	  @CountCombinationsInserted INT = NULL OUTPUT
	, @CountCombinationsUpdated  INT = NULL OUTPUT
	, @CountCombinationsDeleted  INT = NULL OUTPUT
	, @CountDesignsUpdated       INT = NULL OUTPUT
	, @By VARCHAR(25)                = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @CountCombinationsInserted = NULL;
	SET @CountCombinationsUpdated  = NULL;
	SET @CountCombinationsDeleted  = NULL;
	IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	EXEC [qan].[MergeOsatBuildCombinations] @CountCombinationsInserted OUTPUT, @CountCombinationsUpdated OUTPUT, @CountCombinationsDeleted OUTPUT, @By;

	UPDATE P SET
		P.[MixTypeId] = S.[MixTypeId]
	FROM [qan].[Products] AS P
	INNER JOIN
	(
		SELECT
			  [DesignId]
			, [MixTypeId] = CASE WHEN [MinPartUseTypeId] = [MaxPartUseTypeId] THEN [MinPartUseTypeId] ELSE 3 END
		FROM
		(
			SELECT
				  [DesignId]         = [DesignId]
				, [MinPartUseTypeId] = MIN([PartUseTypeId])
				, [MaxPartUseTypeId] = MAX([PartUseTypeId])
			FROM [qan].[OsatBuildCombinations] AS C WITH (NOLOCK)
			GROUP BY [DesignId]
		) AS T
	) AS S
	ON (S.[DesignId] = P.[Id])
	WHERE P.[MixTypeId] IS NULL OR P.[MixTypeId] <> S.[MixTypeId];

	SET @CountDesignsUpdated = @@ROWCOUNT;

END
