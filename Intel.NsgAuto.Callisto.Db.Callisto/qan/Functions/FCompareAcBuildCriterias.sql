-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-30 12:40:03.080
-- Description  : Compares all auto checker build criterias in the input tables together, based on
--                BuildCombinationId. The primary tables should have either 0 or 1 records for a
--                BuildCombinationId (not multiple).
-- ================================================================================================
CREATE FUNCTION [qan].[FCompareAcBuildCriterias]
(
	  @AcBuildCriterias1           [qan].[IAcBuildCriteriasCompare]          READONLY
	, @AcBuildCriterias2           [qan].[IAcBuildCriteriasCompare]          READONLY
	, @AcBuildCriteriaConditions1  [qan].[IAcBuildCriteriaConditionsCompare] READONLY
	, @AcBuildCriteriaConditions2  [qan].[IAcBuildCriteriaConditionsCompare] READONLY
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
		  'AcBuildCriteria'
		, [BuildCombinationId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareAcBuildCriteriaFields](@AcBuildCriterias1, @AcBuildCriterias2);

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
		  'AcBuildCriteriaCondition'
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
	FROM [qan].[FCompareAcBuildCriteriaConditionFields](@AcBuildCriteriaConditions1, @AcBuildCriteriaConditions2);

	RETURN;

END
