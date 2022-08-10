-- ==================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-22 11:54:15.933
-- Description  : Compares all MM recipes in the input tables together, based on PCode. The MMRecipe
--                tables should have either 0 or 1 records for a pcode (not multiple).
-- ==================================================================================================
CREATE FUNCTION [qan].[FCompareMMRecipes]
(
	  @MMRecipes1        [qan].[IMMRecipesCompare] READONLY
	, @MMRecipes2        [qan].[IMMRecipesCompare] READONLY
	, @AssociatedItems1  [qan].[IMMRecipeAssociatedItemsCompare] READONLY
	, @AssociatedItems2  [qan].[IMMRecipeAssociatedItemsCompare] READONLY
)
RETURNS @Result TABLE
(
	  [EntityType]       VARCHAR(50)
	, [PCode]            VARCHAR(10)
	, [ItemId]           VARCHAR(21)
	, [AttributeTypeId]  INT
	, [MissingFrom]      TINYINT
	, [Id1]              BIGINT
	, [Id2]              BIGINT
	, [Field]            VARCHAR(100)
	, [Different]        BIT
	, [Value1]           VARCHAR(MAX)
	, [Value2]           VARCHAR(MAX)
)
AS
BEGIN

	-- types used for comparing
	DECLARE @ProductLabels1 [qan].[IMMRecipeProductLabelsCompare];
	DECLARE @ProductLabels2 [qan].[IMMRecipeProductLabelsCompare];
	DECLARE @ProductLabelAttributes1 [qan].[IMMRecipeProductLabelAttributesCompare];
	DECLARE @ProductLabelAttributes2 [qan].[IMMRecipeProductLabelAttributesCompare];
	DECLARE @MATAttributeValues1 [qan].[IMMRecipeMATAttributeValuesCompare];
	DECLARE @MATAttributeValues2 [qan].[IMMRecipeMATAttributeValuesCompare];

	INSERT INTO @ProductLabels1 ([PCode], [Id], [ProductionProductCode], [ProductFamilyId], [CustomerId], [ProductFamilyNameSeriesId], [Capacity], [ModelString], [VoltageCurrent], [InterfaceSpeed], [OpalTypeId], [KCCId], [CanadianStringClass])
	SELECT M.[PCode], PL.[Id], PL.[ProductionProductCode], PL.[ProductFamilyId], PL.[CustomerId], PL.[ProductFamilyNameSeriesId], PL.[Capacity], PL.[ModelString], PL.[VoltageCurrent], PL.[InterfaceSpeed], PL.[OpalTypeId], PL.[KCCId], PL.[CanadianStringClass]
	FROM @MMRecipes1 AS M INNER JOIN [qan].[ProductLabels] AS PL WITH (NOLOCK) ON (M.[ProductLabelId] = PL.[Id])

	INSERT INTO @ProductLabels2 ([PCode], [Id], [ProductionProductCode], [ProductFamilyId], [CustomerId], [ProductFamilyNameSeriesId], [Capacity], [ModelString], [VoltageCurrent], [InterfaceSpeed], [OpalTypeId], [KCCId], [CanadianStringClass])
	SELECT M.[PCode], PL.[Id], PL.[ProductionProductCode], PL.[ProductFamilyId], PL.[CustomerId], PL.[ProductFamilyNameSeriesId], PL.[Capacity], PL.[ModelString], PL.[VoltageCurrent], PL.[InterfaceSpeed], PL.[OpalTypeId], PL.[KCCId], PL.[CanadianStringClass]
	FROM @MMRecipes2 AS M INNER JOIN [qan].[ProductLabels] AS PL WITH (NOLOCK) ON (M.[ProductLabelId] = PL.[Id])

	INSERT INTO @ProductLabelAttributes1 ([PCode], [AttributeTypeId], [Id], [Value])
	SELECT P.[PCode], A.[AttributeTypeId], A.[Id], A.[Value]
	FROM @ProductLabels1 AS P INNER JOIN [qan].[ProductLabelAttributes] AS A WITH (NOLOCK) ON (A.[ProductLabelId] = P.[Id])

	INSERT INTO @ProductLabelAttributes2 ([PCode], [AttributeTypeId], [Id], [Value])
	SELECT P.[PCode], A.[AttributeTypeId], A.[Id], A.[Value]
	FROM @ProductLabels2 AS P INNER JOIN [qan].[ProductLabelAttributes] AS A WITH (NOLOCK) ON (A.[ProductLabelId] = P.[Id])

	INSERT INTO @MATAttributeValues1 ([Id], [PCode], [AssociatedItemId], [AttributeTypeId], [Value], [Operator], [DataType])
	SELECT V.[Id], I.[PCode], I.[ItemId], V.[AttributeTypeId], V.[Value], V.[Operator], V.[DataType]
	FROM @AssociatedItems1 AS I INNER JOIN [qan].[MATAttributeValues] AS V WITH (NOLOCK) ON (V.[MATId] = I.[MatId])

	INSERT INTO @MATAttributeValues2 ([Id], [PCode], [AssociatedItemId], [AttributeTypeId], [Value], [Operator], [DataType])
	SELECT V.[Id], I.[PCode], I.[ItemId], V.[AttributeTypeId], V.[Value], V.[Operator], V.[DataType]
	FROM @AssociatedItems2 AS I INNER JOIN [qan].[MATAttributeValues] AS V WITH (NOLOCK) ON (V.[MATId] = I.[MatId])

	INSERT INTO @Result
	(
		  [EntityType]
		, [PCode]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	)
	SELECT
		  'MMRecipe'
		, [PCode]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareMMRecipeFields](@MMRecipes1, @MMRecipes2);

	INSERT INTO @Result
	(
		  [EntityType]
		, [PCode]
		, [ItemId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	)
	SELECT
		  'MMRecipeAssociatedItem'
		, [PCode]
		, [ItemId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareMMRecipeAssociatedItemFields](@AssociatedItems1, @AssociatedItems2);

	INSERT INTO @Result
	(
		  [EntityType]
		, [PCode]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	)
	SELECT
		  'ProductLabel'
		, [PCode]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareMMRecipeProductLabelFields](@ProductLabels1, @ProductLabels2);

	INSERT INTO @Result
	(
		  [EntityType]
		, [PCode]
		, [AttributeTypeId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	)
	SELECT
		  'ProductLabelAttribute'
		, [PCode]
		, [AttributeTypeId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareMMRecipeProductLabelAttributeFields](@ProductLabelAttributes1, @ProductLabelAttributes2);

	INSERT INTO @Result
	(
		  [EntityType]
		, [PCode]
		, [AttributeTypeId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
	)
	SELECT
		  'MATAttributeValue'
		, [PCode]
		, [AttributeTypeId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
	FROM [qan].[FCompareMMRecipeMATAttributeValues](@MATAttributeValues1, @MATAttributeValues2);

	RETURN;

END
