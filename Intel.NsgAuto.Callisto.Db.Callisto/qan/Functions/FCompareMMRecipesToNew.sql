-- ======================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-22 12:13:33.787
-- Description  : Compares system MM recipes to ones generated from Speed data.
-- Example      : DECLARE @PCodes [qan].[IPCodes];
--                INSERT INTO @PCodes SELECT TOP 5 DISTINCT [PCode] FROM [qan].[MMRecipes] WITH (NOLOCK);
--                SELECT * FROM [qan].[FCompareMMRecipesToNew](@PCodes);
-- ======================================================================================================
CREATE FUNCTION [qan].[FCompareMMRecipesToNew]
(
	  @PCodes [qan].[IPCodes] READONLY
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

	DECLARE @MMRecipes1 [qan].[IMMRecipesCompare]; -- generated from speed data
	DECLARE @MMRecipes2 [qan].[IMMRecipesCompare]; -- system
	DECLARE @AssociatedItems1 [qan].[IMMRecipeAssociatedItemsCompare]; -- generated from speed data
	DECLARE @AssociatedItems2 [qan].[IMMRecipeAssociatedItemsCompare]; -- system

	INSERT INTO @MMRecipes1 ([Id], [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId])
	SELECT NULL, [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId]
	FROM [qan].[FMMRecipesNewCore](@PCodes);

	-- get only the latest (i.e. highest id) mm recipes in an appropriate status
	INSERT INTO @MMRecipes2 ([Id], [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId])
	SELECT M.[Id], M.[PCode], M.[ProductName], M.[ProductFamilyId], M.[MOQ], M.[ProductionProductCode], M.[SCode], M.[FormFactorId], M.[CustomerId], M.[PRQDate], M.[CustomerQualStatusId], M.[SCodeProductCode], M.[ModelString], M.[PLCStageId], M.[ProductLabelId]
	FROM [qan].[MMRecipes] AS M WITH (NOLOCK) INNER JOIN @PCodes AS P ON (P.[PCode] = M.[PCode])
	WHERE [Id] IN (SELECT MAX(M2.[Id]) AS [MaxId] FROM [qan].[MMRecipes] AS M2 WITH (NOLOCK) INNER JOIN [ref].[Statuses] AS S WITH (NOLOCK) ON (S.[Id] = M2.[StatusId]) WHERE S.[Name] IN ('Complete', 'Draft', 'In Review', 'Submitted') GROUP BY M2.[PCode]);

	INSERT INTO @AssociatedItems1 ([PCode], [ItemId], [Id], [MATId], [SpeedItemCategoryId], [Revision], [SpeedBomAssociationTypeId])
	SELECT [PCode], [ItemId], NULL, [MATId], [SpeedItemCategoryId], [Revision], [SpeedBomAssociationTypeId]
	FROM [qan].[FMMRecipesAssociatedItemsNewCore](@PCodes);

	INSERT INTO @AssociatedItems2 ([PCode], [ItemId], [Id], [MATId], [SpeedItemCategoryId], [Revision], [SpeedBomAssociationTypeId])
	SELECT M.[PCode], I.[ItemId], I.[Id], I.[MATId], I.[SpeedItemCategoryId], I.[Revision], I.[SpeedBomAssociationTypeId]
	FROM @MMRecipes2 AS M INNER JOIN [qan].[MMRecipeAssociatedItems] AS I WITH (NOLOCK) ON (I.[MMRecipeId] = M.[Id]);

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
	FROM [qan].[FCompareMMRecipes](@MMRecipes1, @MMRecipes2, @AssociatedItems1, @AssociatedItems2);

	RETURN;

END
