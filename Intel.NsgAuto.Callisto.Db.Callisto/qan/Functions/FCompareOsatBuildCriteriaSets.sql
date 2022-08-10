-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-03 13:25:16.630
-- Description  : Compares all osat build criteria sets in the input tables together, based on
--                BuildCombinationId. The primary tables should have either 0 or 1 records for a
--                BuildCombinationId (not multiple).
-- ================================================================================================
CREATE FUNCTION [qan].[FCompareOsatBuildCriteriaSets]
(
	  @BuildCriteriaSets1        [qan].[IOsatBuildCriteriaSetsCompare]        READONLY
	, @BuildCriteriaSets2        [qan].[IOsatBuildCriteriaSetsCompare]        READONLY
	, @BuildCriterias1           [qan].[IOsatBuildCriteriasCompare]           READONLY
	, @BuildCriterias2           [qan].[IOsatBuildCriteriasCompare]           READONLY
	, @BuildCriteriaConditions1  [qan].[IOsatBuildCriteriaConditionsCompare]  READONLY
	, @BuildCriteriaConditions2  [qan].[IOsatBuildCriteriaConditionsCompare]  READONLY
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

	INSERT INTO @Result
	(
		  [EntityType]
		, [BuildCombinationId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	)
	SELECT
		  'OsatBuildCriteriaSet'
		, [BuildCombinationId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareOsatBuildCriteriaSetFields](@BuildCriteriaSets1, @BuildCriteriaSets2);

	INSERT INTO @Result
	(
		  [EntityType]
		, [BuildCombinationId]
		, [BuildCriteriaOrdinal]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	)
	SELECT
		  'OsatBuildCriteria'
		, [BuildCombinationId]
		, [Ordinal]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareOsatBuildCriteriaFields](@BuildCriterias1, @BuildCriterias2);

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
		  'OsatBuildCriteriaCondition'
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
	FROM [qan].[FCompareOsatBuildCriteriaConditionFields](@BuildCriteriaConditions1, @BuildCriteriaConditions2);

	RETURN;

END
