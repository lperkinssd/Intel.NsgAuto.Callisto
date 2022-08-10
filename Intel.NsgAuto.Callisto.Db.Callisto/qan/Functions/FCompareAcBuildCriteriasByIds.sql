-- ==========================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-30 12:50:36.567
-- Description  : Compares two auto checker build criterias. They should have the same BuildCombinationId.
-- Example      : SELECT * FROM [qan].[FCompareAcBuildCriteriasByIds](@Id1, @Id2);
-- ==========================================================================================================
CREATE FUNCTION [qan].[FCompareAcBuildCriteriasByIds]
(
	  @Id1 BIGINT
	, @Id2 BIGINT
)
RETURNS @Result TABLE
(
	  [EntityType]             VARCHAR(50)
	, [BuildCombinationId]     INT
	, [AttributeTypeId]        INT
	, [ComparisonOperationId]  INT
	, [MissingFrom]            TINYINT
	, [Id1]                    BIGINT
	, [Id2]                    BIGINT
	, [Field]                  VARCHAR(100)
	, [Different]              BIT
	, [Value1]                 VARCHAR(MAX)
	, [Value2]                 VARCHAR(MAX)
)
AS
BEGIN

	DECLARE @Record1 [qan].[IAcBuildCriteriasCompare];
	DECLARE @Record2 [qan].[IAcBuildCriteriasCompare];
	DECLARE @Conditions1 [qan].[IAcBuildCriteriaConditionsCompare];
	DECLARE @Conditions2 [qan].[IAcBuildCriteriaConditionsCompare];

	INSERT INTO @Record1 ([Id], [BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId], [EffectiveOn])
	SELECT [Id], [BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId], [EffectiveOn]
	FROM [qan].[AcBuildCriterias] WITH (NOLOCK) WHERE [Id] = @Id1;

	INSERT INTO @Record2 ([Id], [BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId], [EffectiveOn])
	SELECT [Id], [BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId], [EffectiveOn]
	FROM [qan].[AcBuildCriterias] WITH (NOLOCK) WHERE [Id] = @Id2;

	INSERT INTO @Conditions1 ([BuildCombinationId], [AttributeTypeId], [ComparisonOperationId], [Id], [Value])
	SELECT B.[BuildCombinationId], C.[AttributeTypeId], C.[ComparisonOperationId], C.[Id], C.[Value]
	FROM @Record1 AS B INNER JOIN [qan].[AcBuildCriteriaConditions] AS C WITH (NOLOCK) ON (C.[BuildCriteriaId] = B.[Id]);

	INSERT INTO @Conditions2 ([BuildCombinationId], [AttributeTypeId], [ComparisonOperationId], [Id], [Value])
	SELECT B.[BuildCombinationId], C.[AttributeTypeId], C.[ComparisonOperationId], C.[Id], C.[Value]
	FROM @Record2 AS B INNER JOIN [qan].[AcBuildCriteriaConditions] AS C WITH (NOLOCK) ON (C.[BuildCriteriaId] = B.[Id]);

	INSERT INTO @Result
	(
		  [EntityType]
		, [BuildCombinationId]
		, [AttributeTypeId]
		, [ComparisonOperationId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	)
	SELECT
		  [EntityType]
		, [BuildCombinationId]
		, [AttributeTypeId]
		, [ComparisonOperationId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareAcBuildCriterias](@Record1, @Record2, @Conditions1, @Conditions2);

	RETURN;

END
