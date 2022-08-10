-- =============================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-01 16:22:33.973
-- Description  : Gets all data needed for creating a new osat build criteria set. If @Id is not null and valid, record sets for all versions
--                of that specific build criteria will be included as well. The build criteria conditions will only be included for @Id.
-- Example      : EXEC [qan].[GetOsatBuildCriteriaSetCreate] 'bricschx', NULL, 1;
-- =============================================================================================================================================
CREATE PROCEDURE [qan].[GetOsatBuildCriteriaSetCreate]
(
	  @UserId              VARCHAR(25)
	, @BuildCombinationId  INT         = NULL
	, @Id                  BIGINT      = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DesignId INT;

	IF (@Id IS NOT NULL)
	BEGIN
		-- if @Id is a valid build criteria id, then set variables based on it
		SELECT
			  @Id                 = MAX([Id])
			, @BuildCombinationId = MAX([BuildCombinationId])
			, @DesignId           = MAX([BuildCombinationDesignId])
		FROM [qan].[FOsatBuildCriteriaSets](@Id, @UserId, NULL, NULL, NULL, NULL, @BuildCombinationId);
	END
	ELSE IF (@BuildCombinationId IS NOT NULL)
	BEGIN
		-- if @BuildCombinationId is a valid build combination id, then set variables based on it
		SELECT
			  @Id                 = MAX([PorBuildCriteriaSetId])
			, @BuildCombinationId = MAX([Id])
			, @DesignId           = MAX([DesignId])
		FROM [qan].[FOsatBuildCombinations](@BuildCombinationId, @UserId, NULL, @DesignId, NULL, NULL, NULL, NULL, NULL, NULL);
	END;

	-- result set #1: attribute types
	SELECT * FROM [qan].[FOsatAttributeTypes](NULL, NULL, NULL) ORDER BY [Name];

	-- result set #2: attribute data types
	SELECT * FROM [qan].[FOsatAttributeDataTypes](NULL, NULL) ORDER BY [Id];

	-- result set #3: attribute type values
	SELECT * FROM [qan].[FOsatAttributeTypeValues](NULL, NULL, NULL, NULL) ORDER BY [AttributeTypeName], [Value], [Id];

	-- result set #4: comparison operations
	SELECT * FROM [qan].[FOsatComparisonOperations](NULL, NULL, 0, NULL, NULL) ORDER BY [Id];

	-- result set #5: data type comparison operations
	SELECT * FROM [ref].[OsatAttributeDataTypeOperations] WITH (NOLOCK) ORDER BY [AttributeDataTypeId], [ComparisonOperationId];

	-- result set #6: designs (that are associated with at least one build combination)
	SELECT * FROM [qan].[FProducts](NULL, @UserId, NULL, NULL, NULL, NULL) WHERE [Id] IN (SELECT [DesignId] FROM [qan].[OsatBuildCombinations] WITH (NOLOCK)) ORDER BY [Name];

	-- result set #7: build combinations; all that are associated with @DesignId, otherwise an empty recordset
	SELECT * FROM [qan].[FOsatBuildCombinations](NULL, @UserId, NULL, ISNULL(@DesignId, 0), NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [Id];

	-- result set #8: build criteria set templates
	SELECT * FROM [qan].[FOsatBuildCriteriaSetTemplates](NULL, NULL, NULL) ORDER BY [Id];

	-- result set #9: build criteria templates
	SELECT * FROM [qan].[FOsatBuildCriteriaTemplates](NULL, NULL, NULL) ORDER BY [SetTemplateId], [Ordinal], [Id];

	-- result set #10: build criteria template conditions
	SELECT * FROM [qan].[FOsatBuildCriteriaTemplateConditions](NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [SetTemplateId], [TemplateId], [AttributeTypeName], [Id];

	SELECT * FROM [qan].Osats

	IF (@Id IS NOT NULL OR @BuildCombinationId IS NOT NULL)
	BEGIN
		-- result set #11: build criteria sets (not just for @Id, but all matching: @BuildCombinationId)
		SELECT * FROM [qan].[FOsatBuildCriteriaSets](NULL, @UserId, NULL, NULL, NULL, NULL, @BuildCombinationId) ORDER BY [Id] DESC;

		-- result set #12: build criterias; all that are associated with @Id, otherwise an empty recordset
		SELECT * FROM [qan].[FOsatBuildCriterias](NULL, ISNULL(@Id, 0), NULL) ORDER BY [Ordinal], [Id];

		-- result set #13: build criteria conditions; all that are associated with @Id, otherwise an empty recordset
		SELECT * FROM [qan].[FOsatBuildCriteriaConditions](NULL, ISNULL(@Id, 0), NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [AttributeTypeName], [ComparisonOperationName], [Id];
	END;

	

END
