-- ==========================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 12:31:10.580
-- Description  : Gets all auto checker build criteria versions matching the input and also returns
--                conditions for the one with [Id] = @Id (or the most recent version id if @Id is null)
-- Example      : EXEC [qan].[GetAcBuildCriteriaAndVersions] 'bricschx', 1, 2, 1, NULL;
-- ==========================================================================================================
CREATE PROCEDURE [qan].[GetAcBuildCriteriaAndVersions]
(
	  @UserId                 VARCHAR(25)
	, @DesignId               INT
	, @FabricationFacilityId  INT
	, @TestFlowId             INT
	, @ProbeConversionId      INT
	, @Id                     BIGINT      = NULL
	, @BuildCombinationId     INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Ids TABLE ([Id] BIGINT NOT NULL);
	DECLARE @TestFlowIdIsNull BIT;
	DECLARE @ProbeConversionIdIsNull BIT;
	IF (@TestFlowId IS NULL) SET @TestFlowIdIsNull = 1;
	IF (@ProbeConversionId IS NULL) SET @ProbeConversionIdIsNull = 1;

	INSERT INTO @Ids SELECT [Id] FROM [qan].[AcBuildCriterias] WITH (NOLOCK)
	WHERE [DesignId] = @DesignId AND [FabricationFacilityId] = @FabricationFacilityId
		AND (([TestFlowId] IS NULL AND @TestFlowId IS NULL) OR ([TestFlowId] = @TestFlowId))
		AND (([ProbeConversionId] IS NULL AND @ProbeConversionId IS NULL) OR ([ProbeConversionId] = @ProbeConversionId))
		AND (@BuildCombinationId IS NULL OR [BuildCombinationId] = @BuildCombinationId);

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

	-- record set #1: build criterias matching @DesignId, @FabricationFacilityId, @TestFlowId, and @ProbeConversionId
	SELECT * FROM [qan].[FAcBuildCriterias](NULL, @UserId, NULL, NULL, NULL, NULL, @BuildCombinationId, @DesignId, @FabricationFacilityId, @TestFlowIdIsNull, @TestFlowId, @ProbeConversionIdIsNull, @ProbeConversionId) ORDER BY [Id] DESC;

	-- record set #2: build criteria conditions
	IF (@Id IS NOT NULL)
	BEGIN
		SELECT * FROM [qan].[FAcBuildCriteriaConditions](NULL, @UserId, @Id, NULL, NULL, NULL, NULL, NULL) ORDER BY [AttributeTypeName], [Id];
	END;

END
