-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-01 16:20:11.173
-- Description  : Gets all osat build criteria set versions matching the specified build combination id and also
--                returns conditions for the one with [Id] = @Id (or the most recent version id if @Id is null)
-- Example      : EXEC [qan].[GetOsatBuildCriteriaSetAndVersions] 'bricschx', 1, NULL;
-- ===============================================================================================================
CREATE PROCEDURE [qan].[GetOsatBuildCriteriaSetAndVersions]
(
	  @UserId              VARCHAR(25)
	, @BuildCombinationId  INT
	, @Id                  BIGINT      = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Ids TABLE ([Id] BIGINT NOT NULL);

	INSERT INTO @Ids SELECT [Id] FROM [qan].[OsatBuildCriteriaSets] WITH (NOLOCK) WHERE [BuildCombinationId] = @BuildCombinationId;

	IF (@@ROWCOUNT > 0)
	BEGIN
		-- make sure @Id is actually in @Ids and if not set it to null
		IF (@Id IS NOT NULL AND NOT EXISTS(SELECT 1 FROM @Ids WHERE [Id] = @Id)) SET @Id = NULL;

		-- if @Id is null set it to the maximum id in @Ids
		IF (@Id IS NULL)
		BEGIN
			SELECT @Id = MAX([Id]) FROM @Ids;
		END;
	END;

	-- record set #1: build criterias sets matching the build combination id
	SELECT * FROM [qan].[FOsatBuildCriteriaSets](NULL, @UserId, NULL, NULL, NULL, NULL, @BuildCombinationId) ORDER BY [Id] DESC;

	IF (@Id IS NOT NULL)
	BEGIN
		-- record set #2: build criterias
		SELECT * FROM [qan].[FOsatBuildCriterias](NULL, @Id, NULL) ORDER BY [Ordinal], [Id];

		-- record set #3: build criteria conditions
		SELECT * FROM [qan].[FOsatBuildCriteriaConditions](NULL, @Id, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [AttributeTypeName], [ComparisonOperationName], [Id];
	END;

END
