-- ==============================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-15 16:25:59.027
-- Description  : Compares records from the two tables passed in by joining on PCode and listing the differences
-- Example      : DECLARE @Records1 [qan].[IMMRecipeProductLabelsCompare];
--                DECLARE @Records2 [qan].[IMMRecipeProductLabelsCompare];
--                DECLARE @PCode VARCHAR(10) = '000000';
--                INSERT INTO @Records1 ([PCode], [Id], [ProductionProductCode], [ProductFamilyId], [CustomerId], [ProductFamilyNameSeriesId], [Capacity], [ModelString], [VoltageCurrent], [InterfaceSpeed], [OpalTypeId], [KCCId], [CanadianStringClass])
--                SELECT @PCode, [Id], [ProductionProductCode], [ProductFamilyId], [CustomerId], [ProductFamilyNameSeriesId], [Capacity], [ModelString], [VoltageCurrent], [InterfaceSpeed], [OpalTypeId], [KCCId], [CanadianStringClass] FROM [qan].[ProductLabels] WITH (NOLOCK) WHERE [Id] = 1;
--                INSERT INTO @Records2 ([PCode], [Id], [ProductionProductCode], [ProductFamilyId], [CustomerId], [ProductFamilyNameSeriesId], [Capacity], [ModelString], [VoltageCurrent], [InterfaceSpeed], [OpalTypeId], [KCCId], [CanadianStringClass])
--                SELECT @PCode, [Id], [ProductionProductCode], [ProductFamilyId], [CustomerId], [ProductFamilyNameSeriesId], [Capacity], [ModelString], [VoltageCurrent], [InterfaceSpeed], [OpalTypeId], [KCCId], [CanadianStringClass] FROM [qan].[ProductLabels] WITH (NOLOCK) WHERE [Id] = 2;
--                SELECT * FROM [qan].[FCompareMMRecipeProductLabelFields](@Records1, @Records2);
-- ==============================================================================================================
CREATE FUNCTION [qan].[FCompareMMRecipeProductLabelFields]
(
	  @Records1 [qan].[IMMRecipeProductLabelsCompare] READONLY
	, @Records2 [qan].[IMMRecipeProductLabelsCompare] READONLY
)
RETURNS TABLE AS RETURN
(

	WITH
	  R1 AS
	(
		SELECT * FROM @Records1
	)
	, R2 AS
	(
		SELECT * FROM @Records2
	)
	SELECT
		  [PCode] = ISNULL(R1.[PCode], R2.[PCode])
		, [MissingFrom] = CAST(CASE WHEN (R1.[PCode] = R2.[PCode]) OR (R1.[PCode] IS NULL AND R2.[PCode] IS NULL) THEN NULL WHEN (R1.[PCode] IS NULL) THEN 1 ELSE 2 END AS TINYINT)
		, [Id1] = R1.[Id]
		, [Id2] = R2.[Id]
		, CA.[Field]
		, CA.[Different]
		, CA.[Value1]
		, CA.[Value2]
	FROM R1 FULL OUTER JOIN R2 ON (R1.[PCode] = R2.[PCode])
	CROSS APPLY
	(
		VALUES
		  (
			  'ProductionProductCode'
			, CAST(CASE WHEN (R1.[ProductionProductCode] = R2.[ProductionProductCode]) OR (R1.[ProductionProductCode] IS NULL AND R2.[ProductionProductCode] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[ProductionProductCode] AS VARCHAR(MAX))
			, CAST(R2.[ProductionProductCode] AS VARCHAR(MAX))
		  )
		, (
			  'ProductFamilyId'
			, CAST(CASE WHEN (R1.[ProductFamilyId] = R2.[ProductFamilyId]) OR (R1.[ProductFamilyId] IS NULL AND R2.[ProductFamilyId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[ProductFamilyId] AS VARCHAR(MAX))
			, CAST(R2.[ProductFamilyId] AS VARCHAR(MAX))
		  )
		, (
			  'CustomerId'
			, CAST(CASE WHEN (R1.[CustomerId] = R2.[CustomerId]) OR (R1.[CustomerId] IS NULL AND R2.[CustomerId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[CustomerId] AS VARCHAR(MAX))
			, CAST(R2.[CustomerId] AS VARCHAR(MAX))
		  )
		, (
			  'ProductFamilyNameSeriesId'
			, CAST(CASE WHEN (R1.[ProductFamilyNameSeriesId] = R2.[ProductFamilyNameSeriesId]) OR (R1.[ProductFamilyNameSeriesId] IS NULL AND R2.[ProductFamilyNameSeriesId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[ProductFamilyNameSeriesId] AS VARCHAR(MAX))
			, CAST(R2.[ProductFamilyNameSeriesId] AS VARCHAR(MAX))
		  )
		, (
			  'Capacity'
			, CAST(CASE WHEN (R1.[Capacity] = R2.[Capacity]) OR (R1.[Capacity] IS NULL AND R2.[Capacity] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[Capacity] AS VARCHAR(MAX))
			, CAST(R2.[Capacity] AS VARCHAR(MAX))
		  )
		, (
			  'ModelString'
			, CAST(CASE WHEN (R1.[ModelString] = R2.[ModelString]) OR (R1.[ModelString] IS NULL AND R2.[ModelString] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[ModelString] AS VARCHAR(MAX))
			, CAST(R2.[ModelString] AS VARCHAR(MAX))
		  )
		, (
			  'VoltageCurrent'
			, CAST(CASE WHEN (R1.[VoltageCurrent] = R2.[VoltageCurrent]) OR (R1.[VoltageCurrent] IS NULL AND R2.[VoltageCurrent] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[VoltageCurrent] AS VARCHAR(MAX))
			, CAST(R2.[VoltageCurrent] AS VARCHAR(MAX))
		  )
		, (
			  'InterfaceSpeed'
			, CAST(CASE WHEN (R1.[InterfaceSpeed] = R2.[InterfaceSpeed]) OR (R1.[InterfaceSpeed] IS NULL AND R2.[InterfaceSpeed] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[InterfaceSpeed] AS VARCHAR(MAX))
			, CAST(R2.[InterfaceSpeed] AS VARCHAR(MAX))
		  )
		, (
			  'OpalTypeId'
			, CAST(CASE WHEN (R1.[OpalTypeId] = R2.[OpalTypeId]) OR (R1.[OpalTypeId] IS NULL AND R2.[OpalTypeId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[OpalTypeId] AS VARCHAR(MAX))
			, CAST(R2.[OpalTypeId] AS VARCHAR(MAX))
		  )
		, (
			  'KCCId'
			, CAST(CASE WHEN (R1.[KCCId] = R2.[KCCId]) OR (R1.[KCCId] IS NULL AND R2.[KCCId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[KCCId] AS VARCHAR(MAX))
			, CAST(R2.[KCCId] AS VARCHAR(MAX))
		  )
		, (
			  'CanadianStringClass'
			, CAST(CASE WHEN (R1.[CanadianStringClass] = R2.[CanadianStringClass]) OR (R1.[CanadianStringClass] IS NULL AND R2.[CanadianStringClass] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[CanadianStringClass] AS VARCHAR(MAX))
			, CAST(R2.[CanadianStringClass] AS VARCHAR(MAX))
		  )
	) AS CA([Field], [Different], [Value1], [Value2])

)
