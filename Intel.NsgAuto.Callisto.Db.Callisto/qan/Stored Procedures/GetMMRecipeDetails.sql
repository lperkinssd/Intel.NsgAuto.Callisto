-- =============================================================
-- Author       : bricschx
-- Create date  : 2020-12-21 12:36:07.913
-- Description  : Gets the details for a mm recipe
-- Example      : EXEC [qan].[GetMMRecipeDetails] 'bricschx', 1
-- =============================================================
CREATE PROCEDURE [qan].[GetMMRecipeDetails]
(
	  @UserId VARCHAR(25)
	, @Id BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ProductLabelId INT;
	DECLARE @MATIds [qan].[IInts];

	-- #1 result set: mm recipe record
	SELECT * FROM [qan].[FMMRecipes](@Id, NULL, NULL, NULL, NULL) ORDER BY [Id];

	-- #2 result set: nand/media items
	SELECT * FROM [qan].[FMMRecipeAssociatedItems](NULL, @Id, NULL)
	WHERE [SpeedItemCategoryCode] = 'NAND_MEDIA'
	ORDER BY [SpeedItemCategoryCode] ASC, [SpeedBomAssociationTypeName] DESC, [Id];

	-- #3 result set: nand/media mat attribute values
	INSERT INTO @MATIds SELECT [MATId] FROM [qan].[MMRecipeAssociatedItems] WITH (NOLOCK) WHERE [MMRecipeId] = @Id AND [MATId] IS NOT NULL;
	SELECT * FROM [qan].[FMATAttributeValues2](@MATIds) ORDER BY [MATAttributeTypeName], [Id];

	-- #4 result set: associated items
	SELECT * FROM [qan].[FMMRecipeAssociatedItems](NULL, @Id, NULL)
	WHERE [SpeedItemCategoryCode] IS NULL OR [SpeedItemCategoryCode] != 'NAND_MEDIA'
	ORDER BY [SpeedItemCategoryCode] ASC, [SpeedBomAssociationTypeName] DESC, [Id];

	-- note: the product label functions below will not filter on the product label id if it is null; so set it to a non-existant id (e.g. 0) if it is null
	SELECT @ProductLabelId = ISNULL(MAX([ProductLabelId]), 0) FROM [qan].[MMRecipes] WITH (NOLOCK) WHERE [Id] = @Id;

	-- #5 result set: product label set version record
	SELECT * FROM [qan].[FProductLabels](@ProductLabelId, NULL) ORDER BY [Id];

	-- #6 result set: product label attributes
	SELECT * FROM [qan].[FProductLabelAttributes](NULL, @ProductLabelId, NULL) ORDER BY [Id];

	-- #7 result set: customer qual statuses
	SELECT * FROM [ref].[CustomerQualStatuses] WITH (NOLOCK) ORDER BY [Id];

	-- #8 result set: plc stages
	SELECT * FROM [ref].[PLCStages] WITH (NOLOCK) ORDER BY [Id];

	-- #9 result set: review stages
	SELECT * FROM [qan].[FMMRecipeReviewStages](NULL, @Id, NULL, NULL, NULL, NULL) ORDER BY [Sequence];

	-- #10 result set: review groups
	SELECT * FROM [qan].[FMMRecipeReviewGroups](NULL, @Id, NULL, NULL, NULL);

	-- #11 result set: reviewers
	SELECT * FROM [qan].[FMMRecipeReviewers](NULL, @Id, NULL, NULL, NULL, NULL, NULL, NULL);

	-- #12 result set: review decisions
	SELECT * FROM [qan].[FMMRecipeReviewDecisions](NULL, @Id, NULL, NULL, NULL, NULL);

END
