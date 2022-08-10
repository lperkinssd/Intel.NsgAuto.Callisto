-- ===================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-14 15:36:32.297
-- Description  : Compares records from the two tables passed in by joining on PCode and
--                listing the differences
-- Example      : DECLARE @Records1 [qan].[IMMRecipesCompare];
--                DECLARE @Records2 [qan].[IMMRecipesCompare];
--                INSERT INTO @Records1 ([Id], [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId])
--                SELECT [Id], [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId] FROM [qan].[MMRecipes] WITH (NOLOCK) WHERE [Id] = 1;
--                DECLARE @PCode VARCHAR(10);
--                SELECT @PCode = MAX([PCode]) FROM @Records1;
--                INSERT INTO @Records2 ([Id], [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId])
--                SELECT NULL, [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId] FROM [qan].[SimulateMMRecipeCore](@PCode);
--                SELECT * FROM [qan].[FCompareMMRecipeFields](@Records1, @Records2);
-- ===================================================================================================
CREATE FUNCTION [qan].[FCompareMMRecipeFields]
(
	  @Records1 [qan].[IMMRecipesCompare] READONLY
	, @Records2 [qan].[IMMRecipesCompare] READONLY
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
			  'ProductName'
			, CAST(CASE WHEN (R1.[ProductName] = R2.[ProductName]) OR (R1.[ProductName] IS NULL AND R2.[ProductName] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[ProductName] AS VARCHAR(MAX))
			, CAST(R2.[ProductName] AS VARCHAR(MAX))
		  )
		, (
			  'ProductFamilyId'
			, CAST(CASE WHEN (R1.[ProductFamilyId] = R2.[ProductFamilyId]) OR (R1.[ProductFamilyId] IS NULL AND R2.[ProductFamilyId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[ProductFamilyId] AS VARCHAR(MAX))
			, CAST(R2.[ProductFamilyId] AS VARCHAR(MAX))
		  )
		, (
			  'MOQ'
			, CAST(CASE WHEN (R1.[MOQ] = R2.[MOQ]) OR (R1.[MOQ] IS NULL AND R2.[MOQ] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[MOQ] AS VARCHAR(MAX))
			, CAST(R2.[MOQ] AS VARCHAR(MAX))
		  )
		, (
			  'ProductionProductCode'
			, CAST(CASE WHEN (R1.[ProductionProductCode] = R2.[ProductionProductCode]) OR (R1.[ProductionProductCode] IS NULL AND R2.[ProductionProductCode] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[ProductionProductCode] AS VARCHAR(MAX))
			, CAST(R2.[ProductionProductCode] AS VARCHAR(MAX))
		  )
		, (
			  'SCode'
			, CAST(CASE WHEN (R1.[SCode] = R2.[SCode]) OR (R1.[SCode] IS NULL AND R2.[SCode] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[SCode] AS VARCHAR(MAX))
			, CAST(R2.[SCode] AS VARCHAR(MAX))
		  )
		, (
			  'FormFactorId'
			, CAST(CASE WHEN (R1.[FormFactorId] = R2.[FormFactorId]) OR (R1.[FormFactorId] IS NULL AND R2.[FormFactorId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[FormFactorId] AS VARCHAR(MAX))
			, CAST(R2.[FormFactorId] AS VARCHAR(MAX))
		  )
		, (
			  'CustomerId'
			, CAST(CASE WHEN (R1.[CustomerId] = R2.[CustomerId]) OR (R1.[CustomerId] IS NULL AND R2.[CustomerId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[CustomerId] AS VARCHAR(MAX))
			, CAST(R2.[CustomerId] AS VARCHAR(MAX))
		  )
		, (
			  'PRQDate'
			, CAST(CASE WHEN (R1.[PRQDate] = R2.[PRQDate]) OR (R1.[PRQDate] IS NULL AND R2.[PRQDate] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[PRQDate] AS VARCHAR(MAX))
			, CAST(R2.[PRQDate] AS VARCHAR(MAX))
		  )
		, (
			  'CustomerQualStatusId'
			, CAST(CASE WHEN (R1.[CustomerQualStatusId] = R2.[CustomerQualStatusId]) OR (R1.[CustomerQualStatusId] IS NULL AND R2.[CustomerQualStatusId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[CustomerQualStatusId] AS VARCHAR(MAX))
			, CAST(R2.[CustomerQualStatusId] AS VARCHAR(MAX))
		  )
		, (
			  'SCodeProductCode'
			, CAST(CASE WHEN (R1.[SCodeProductCode] = R2.[SCodeProductCode]) OR (R1.[SCodeProductCode] IS NULL AND R2.[SCodeProductCode] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[SCodeProductCode] AS VARCHAR(MAX))
			, CAST(R2.[SCodeProductCode] AS VARCHAR(MAX))
		  )
		, (
			  'ModelString'
			, CAST(CASE WHEN (R1.[ModelString] = R2.[ModelString]) OR (R1.[ModelString] IS NULL AND R2.[ModelString] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[ModelString] AS VARCHAR(MAX))
			, CAST(R2.[ModelString] AS VARCHAR(MAX))
		  )
		, (
			  'PLCStageId'
			, CAST(CASE WHEN (R1.[PLCStageId] = R2.[PLCStageId]) OR (R1.[PLCStageId] IS NULL AND R2.[PLCStageId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[PLCStageId] AS VARCHAR(MAX))
			, CAST(R2.[PLCStageId] AS VARCHAR(MAX))
		  )
		, (
			  'ProductLabelId'
			, CAST(CASE WHEN (R1.[ProductLabelId] = R2.[ProductLabelId]) OR (R1.[ProductLabelId] IS NULL AND R2.[ProductLabelId] IS NULL) THEN 0 ELSE 1 END AS BIT)
			, CAST(R1.[ProductLabelId] AS VARCHAR(MAX))
			, CAST(R2.[ProductLabelId] AS VARCHAR(MAX))
		  )
	) AS CA([Field], [Different], [Value1], [Value2])

)
