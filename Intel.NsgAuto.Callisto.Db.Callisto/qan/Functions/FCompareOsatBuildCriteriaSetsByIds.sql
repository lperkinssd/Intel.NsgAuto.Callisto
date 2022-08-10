-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-03 13:27:38.880
-- Description  : Compares two osat build criteria sets. They should have the same BuildCombinationId.
-- Example      : SELECT * FROM [qan].[FCompareOsatBuildCriteriaSetsByIds](@Id1, @Id2);
-- =====================================================================================================
CREATE FUNCTION [qan].[FCompareOsatBuildCriteriaSetsByIds]
(
	  @Id1 BIGINT
	, @Id2 BIGINT
)
RETURNS @Result TABLE
(
	  [EntityType]             VARCHAR(50)
	, [BuildCombinationId]     INT
	, [BuildCriteriaOrdinal]   INT
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

	DECLARE @Record1     [qan].[IOsatBuildCriteriaSetsCompare];
	DECLARE @Record2     [qan].[IOsatBuildCriteriaSetsCompare];
	DECLARE @Criterias1  [qan].[IOsatBuildCriteriasCompare];
	DECLARE @Criterias2  [qan].[IOsatBuildCriteriasCompare];
	DECLARE @Conditions1 [qan].[IOsatBuildCriteriaConditionsCompare];
	DECLARE @Conditions2 [qan].[IOsatBuildCriteriaConditionsCompare];

	INSERT INTO @Record1 ([Id], [BuildCombinationId], [EffectiveOn])
	SELECT [Id], [BuildCombinationId], [EffectiveOn]
	FROM [qan].[OsatBuildCriteriaSets] WITH (NOLOCK) WHERE [Id] = @Id1;

	INSERT INTO @Record2 ([Id], [BuildCombinationId], [EffectiveOn])
	SELECT [Id], [BuildCombinationId], [EffectiveOn]
	FROM [qan].[OsatBuildCriteriaSets] WITH (NOLOCK) WHERE [Id] = @Id2;

	INSERT INTO @Criterias1 ([BuildCombinationId], [Ordinal], [Id], [Name])
	SELECT S.[BuildCombinationId], BC.[Ordinal], BC.[Id], BC.[Name]
	FROM @Record1 AS S
	INNER JOIN [qan].[OsatBuildCriterias] AS BC WITH (NOLOCK) ON (BC.[BuildCriteriaSetId] = S.[Id]);

	INSERT INTO @Criterias2 ([BuildCombinationId], [Ordinal], [Id], [Name])
	SELECT S.[BuildCombinationId], BC.[Ordinal], BC.[Id], BC.[Name]
	FROM @Record2 AS S
	INNER JOIN [qan].[OsatBuildCriterias] AS BC WITH (NOLOCK) ON (BC.[BuildCriteriaSetId] = S.[Id]);

	INSERT INTO @Conditions1 ([BuildCombinationId], [BuildCriteriaOrdinal], [AttributeTypeId], [ComparisonOperationId], [Id], [Value])
	SELECT S.[BuildCombinationId], BC.[Ordinal], C.[AttributeTypeId], C.[ComparisonOperationId], C.[Id], C.[Value]
	FROM @Record1 AS S
	INNER JOIN [qan].[OsatBuildCriterias] AS BC WITH (NOLOCK) ON (BC.[BuildCriteriaSetId] = S.[Id])
	INNER JOIN [qan].[OsatBuildCriteriaConditions] AS C WITH (NOLOCK) ON (C.[BuildCriteriaId] = BC.[Id]);

	INSERT INTO @Conditions2 ([BuildCombinationId], [BuildCriteriaOrdinal], [AttributeTypeId], [ComparisonOperationId], [Id], [Value])
	SELECT S.[BuildCombinationId], BC.[Ordinal], C.[AttributeTypeId], C.[ComparisonOperationId], C.[Id], C.[Value]
	FROM @Record2 AS S
	INNER JOIN [qan].[OsatBuildCriterias] AS BC WITH (NOLOCK) ON (BC.[BuildCriteriaSetId] = S.[Id])
	INNER JOIN [qan].[OsatBuildCriteriaConditions] AS C WITH (NOLOCK) ON (C.[BuildCriteriaId] = BC.[Id]);

	INSERT INTO @Result
	(
		  [EntityType]
		, [BuildCombinationId]
		, [BuildCriteriaOrdinal]
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
		, [BuildCriteriaOrdinal]
		, [AttributeTypeId]
		, [ComparisonOperationId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareOsatBuildCriteriaSets](@Record1, @Record2, @Criterias1, @Criterias2, @Conditions1, @Conditions2);

	RETURN;

END
