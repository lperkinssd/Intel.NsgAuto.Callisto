-- =======================================================================
-- Author       : bricschx
-- Create date  : 2020-09-25 11:35:59.747
-- Description  : Creates a new MM recipe for the given PCode
-- Example      : EXEC [qan].[CreateMMRecipe] NULL, 'bricschx', '999Z6H'
-- =======================================================================
CREATE PROCEDURE [qan].[CreateMMRecipe]
(
	  @Id BIGINT OUT
	, @By VARCHAR(25)
	, @PCode VARCHAR(10)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @On DATETIME2(7) = GETUTCDATE();
	DECLARE @Version INT;

	SELECT @Version = (ISNULL(MAX([Version]), 0) + 1) FROM [qan].[MMRecipes] WITH (NOLOCK) WHERE [PCode] = @PCode;

	BEGIN TRANSACTION
		INSERT INTO [qan].[MMRecipes]
		(
			  [Version]
			, [IsPOR]
			, [IsActive]
			, [StatusId]
			, [CreatedBy]
			, [CreatedOn]
			, [UpdatedBy]
			, [UpdatedOn]
			, [PCode]
			, [ProductName]
			, [ProductFamilyId]
			, [MOQ]
			, [ProductionProductCode]
			, [SCode]
			, [FormFactorId]
			, [CustomerId]
			, [PRQDate]
			, [CustomerQualStatusId]
			, [SCodeProductCode]
			, [ModelString]
			, [PLCStageId]
			, [ProductLabelId]
		)
		SELECT TOP 1
			  @Version     -- [Version]
			, M.[IsPOR]
			, M.[IsActive]
			, M.[StatusId]
			, @By          -- [CreatedBy]
			, @On          -- [CreatedOn]
			, @By          -- [UpdatedBy]
			, @On          -- [UpdatedOn]
			, M.[PCode]
			, M.[ProductName]
			, M.[ProductFamilyId]
			, M.[MOQ]
			, M.[ProductionProductCode]
			, M.[SCode]
			, M.[FormFactorId]
			, M.[CustomerId]
			, M.[PRQDate]
			, M.[CustomerQualStatusId]
			, M.[SCodeProductCode]
			, M.[ModelString]
			, M.[PLCStageId]
			, M.[ProductLabelId]
		FROM [qan].[FMMRecipeNewCore](@PCode) AS M;

		SELECT @Id = SCOPE_IDENTITY();

		INSERT INTO [qan].[MMRecipeAssociatedItems]
		(
			  [MMRecipeId]
			, [SpeedItemCategoryId]
			, [ItemId]
			, [Revision]
			, [SpeedBomAssociationTypeId]
			, [MATId]
		)
		SELECT
			  @Id AS [MMRecipeId]
			, [SpeedItemCategoryId]
			, [ItemId]
			, [Revision]
			, [SpeedBomAssociationTypeId]
			, [MATId]
		FROM [qan].[FMMRecipeAssociatedItemsNewCore](@PCode);

	COMMIT;

END
