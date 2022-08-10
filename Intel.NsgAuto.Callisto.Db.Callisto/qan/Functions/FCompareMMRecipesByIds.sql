-- ===============================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-22 18:41:39.080
-- Description  : Compares two MM recipes. They should have the same PCode.
-- Example      : SELECT * FROM [qan].[FCompareMMRecipesByIds](@Id1, @Id2);
-- ===============================================================================================
CREATE FUNCTION [qan].[FCompareMMRecipesByIds]
(
	  @Id1 BIGINT
	, @Id2 BIGINT
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

	DECLARE @Record1 [qan].[IMMRecipesCompare];
	DECLARE @Record2 [qan].[IMMRecipesCompare];
	DECLARE @AssociatedItems1 [qan].[IMMRecipeAssociatedItemsCompare];
	DECLARE @AssociatedItems2 [qan].[IMMRecipeAssociatedItemsCompare];

	INSERT INTO @Record1 ([Id], [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId])
	SELECT [Id], [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId]
	FROM [qan].[MMRecipes] WITH (NOLOCK) WHERE [Id] = @Id1;

	INSERT INTO @Record2 ([Id], [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId])
	SELECT [Id], [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId]
	FROM [qan].[MMRecipes] WITH (NOLOCK) WHERE [Id] = @Id2;

	INSERT INTO @AssociatedItems1 ([PCode], [ItemId], [Id], [MATId], [SpeedItemCategoryId], [Revision], [SpeedBomAssociationTypeId])
	SELECT M.[PCode], I.[ItemId], I.[Id], I.[MATId], I.[SpeedItemCategoryId], I.[Revision], I.[SpeedBomAssociationTypeId]
	FROM @Record1 AS M INNER JOIN [qan].[MMRecipeAssociatedItems] AS I WITH (NOLOCK) ON (I.[MMRecipeId] = M.[Id]);

	INSERT INTO @AssociatedItems2 ([PCode], [ItemId], [Id], [MATId], [SpeedItemCategoryId], [Revision], [SpeedBomAssociationTypeId])
	SELECT M.[PCode], I.[ItemId], I.[Id], I.[MATId], I.[SpeedItemCategoryId], I.[Revision], I.[SpeedBomAssociationTypeId]
	FROM @Record2 AS M INNER JOIN [qan].[MMRecipeAssociatedItems] AS I WITH (NOLOCK) ON (I.[MMRecipeId] = M.[Id]);

	INSERT INTO @Result
	(
		  [EntityType]
		, [PCode]
		, [ItemId]
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
		  [EntityType]
		, [PCode]
		, [ItemId]
		, [AttributeTypeId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareMMRecipes](@Record1, @Record2, @AssociatedItems1, @AssociatedItems2);

	RETURN;

END
