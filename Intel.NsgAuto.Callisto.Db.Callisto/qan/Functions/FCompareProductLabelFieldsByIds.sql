-- ===============================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-14 18:23:07.020
-- Description  : Compares fields for two product labels indicating differences
-- Example      : SELECT * FROM [qan].[FCompareProductLabelFieldsByIds](1, 2);
-- ===============================================================================================
CREATE FUNCTION [qan].[FCompareProductLabelFieldsByIds]
(
	  @Id1 BIGINT
	, @Id2 BIGINT
)
RETURNS @Result TABLE
(
	  [Id1]        BIGINT
	, [Id2]        BIGINT
	, [Field]      VARCHAR(100)
	, [Different]  BIT
	, [Value1]     VARCHAR(MAX)
	, [Value2]     VARCHAR(MAX)
)
AS
BEGIN

	DECLARE @PCode VARCHAR(10) = '000000'; -- dummy value; required for dependent function call below but value not included in output
	DECLARE @Records1 [qan].[IMMRecipeProductLabelsCompare];
	DECLARE @Records2 [qan].[IMMRecipeProductLabelsCompare];

	INSERT INTO @Records1 ([PCode], [Id], [ProductionProductCode], [ProductFamilyId], [CustomerId], [ProductFamilyNameSeriesId], [Capacity], [ModelString], [VoltageCurrent], [InterfaceSpeed], [OpalTypeId], [KCCId], [CanadianStringClass])
	SELECT @PCode, [Id], [ProductionProductCode], [ProductFamilyId], [CustomerId], [ProductFamilyNameSeriesId], [Capacity], [ModelString], [VoltageCurrent], [InterfaceSpeed], [OpalTypeId], [KCCId], [CanadianStringClass] FROM [qan].[ProductLabels] WITH (NOLOCK) WHERE [Id] = @Id1;

	INSERT INTO @Records2 ([PCode], [Id], [ProductionProductCode], [ProductFamilyId], [CustomerId], [ProductFamilyNameSeriesId], [Capacity], [ModelString], [VoltageCurrent], [InterfaceSpeed], [OpalTypeId], [KCCId], [CanadianStringClass])
	SELECT @PCode, [Id], [ProductionProductCode], [ProductFamilyId], [CustomerId], [ProductFamilyNameSeriesId], [Capacity], [ModelString], [VoltageCurrent], [InterfaceSpeed], [OpalTypeId], [KCCId], [CanadianStringClass] FROM [qan].[ProductLabels] WITH (NOLOCK) WHERE [Id] = @Id2;

	INSERT INTO @Result
	(
		  [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	)
	SELECT
		  [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareMMRecipeProductLabelFields](@Records1, @Records2);

	RETURN;

END
