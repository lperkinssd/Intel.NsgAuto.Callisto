-- ====================================================================
-- Author       : bricschx
-- Create date  : 2020-09-25 11:35:59.747
-- Description  : Gets a new MM Recipe for the given PCode
-- Example      : EXEC [qan].[GetMMRecipeNew] 'bricschx', '999Z6H'
-- ====================================================================
CREATE PROCEDURE [qan].[GetMMRecipeNew]
(
	  @UserId VARCHAR(25)
	, @PCode VARCHAR(10)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @By VARCHAR(25) = '';
	DECLARE @Id BIGINT = 0;
	DECLARE @On DATETIME2(7) = GETUTCDATE();
	DECLARE @ProductLabelId INT;
	DECLARE @Version INT;

	DECLARE @MMRecipe AS TABLE
	(
		  [Id]                               BIGINT NOT NULL
		, [Version]                          INT NOT NULL
		, [IsPOR]                            BIT NOT NULL
		, [IsActive]                         BIT NOT NULL
		, [StatusId]                         INT NOT NULL
		, [StatusName]                       VARCHAR(25) NOT NULL
		, [CreatedBy]                        VARCHAR(25) NULL
		, [CreatedOn]                        DATETIME2(7) NOT NULL
		, [UpdatedBy]                        VARCHAR(25) NULL
		, [UpdatedOn]                        DATETIME2(7) NOT NULL
		, [PCode]                            VARCHAR(10) NOT NULL
		, [ProductName]                      VARCHAR(200)
		, [ProductFamilyId]                  INT
		, [ProductFamilyName]                VARCHAR(50)
		, [MOQ]                              INT
		, [ProductionProductCode]            VARCHAR(25)
		, [SCode]                            VARCHAR(10)
		, [FormFactorId]                     INT
		, [FormFactorName]                   VARCHAR(50)
		, [CustomerId]                       INT
		, [CustomerName]                     VARCHAR(50)
		, [PRQDate]                          DATETIME2(7)
		, [CustomerQualStatusId]             INT
		, [CustomerQualStatusName]           VARCHAR(25)
		, [SCodeProductCode]                 VARCHAR(20)
		, [ModelString]                      VARCHAR(20)
		, [PLCStageId]                       INT
		, [PLCStageName]                     VARCHAR(25)
		, [ProductLabelId]                   BIGINT
		, [SubmittedBy]                      VARCHAR(25)
		, [SubmittedOn]                      DATETIME2(7)
	);

	DECLARE @AssociatedItems AS TABLE
	(
		  [Id]                               BIGINT
		, [MMRecipeId]                       BIGINT
		, [MATId]                            INT
		, [SpeedItemCategoryId]              INT
		, [SpeedItemCategoryName]            VARCHAR(50)
		, [SpeedItemCategoryCode]            VARCHAR(25)
		, [ItemId]                           VARCHAR(21)
		, [Revision]                         VARCHAR(2)
		, [SpeedBomAssociationTypeId]        INT
		, [SpeedBomAssociationTypeName]      VARCHAR(20)
		, [SpeedBomAssociationTypeNameSpeed] VARCHAR(20)
		, [SpeedBomAssociationTypeCodeSpeed] VARCHAR(1)
	);

	DECLARE @MATIds [qan].[IInts];

	SELECT @Version = (ISNULL(MAX([Version]), 0) + 1) FROM [qan].[MMRecipes] WITH (NOLOCK) WHERE [PCode] = @PCode;

	INSERT INTO @MMRecipe
	(
		  [Id]
		, [Version]
		, [IsPOR]
		, [IsActive]
		, [StatusId]
		, [StatusName]
		, [CreatedBy]
		, [CreatedOn]
		, [UpdatedBy]
		, [UpdatedOn]
		, [PCode]
		, [ProductName]
		, [ProductFamilyId]
		, [ProductFamilyName]
		, [MOQ]
		, [ProductionProductCode]
		, [SCode]
		, [FormFactorId]
		, [FormFactorName]
		, [CustomerId]
		, [CustomerName]
		, [PRQDate]
		, [CustomerQualStatusId]
		, [CustomerQualStatusName]
		, [SCodeProductCode]
		, [ModelString]
		, [PLCStageId]
		, [PLCStageName]
		, [ProductLabelId]
	)
	SELECT TOP 1
		  @Id                     -- [Id]
		, @Version                -- [Version]
		, [IsPOR]
		, [IsActive]
		, [StatusId]
		, [StatusName]
		, @By                     -- [CreatedBy]
		, @On                     -- [CreatedOn]
		, @By                     -- [UpdatedBy]
		, @On                     -- [UpdatedOn]
		, [PCode]
		, [ProductName]
		, [ProductFamilyId]
		, [ProductFamilyName]
		, [MOQ]
		, [ProductionProductCode]
		, [SCode]
		, [FormFactorId]
		, [FormFactorName]
		, [CustomerId]
		, [CustomerName]
		, [PRQDate]
		, [CustomerQualStatusId]
		, [CustomerQualStatusName]
		, [SCodeProductCode]
		, [ModelString]
		, [PLCStageId]
		, [PLCStageName]
		, [ProductLabelId]
	FROM [qan].[FMMRecipeNewCore](@PCode);

	SELECT @ProductLabelId = MAX([ProductLabelId]) FROM @MMRecipe;

	INSERT INTO @AssociatedItems
	(
		  [Id]
		, [MMRecipeId]
		, [MATId]
		, [SpeedItemCategoryId]
		, [SpeedItemCategoryName]
		, [SpeedItemCategoryCode]
		, [ItemId]
		, [Revision]
		, [SpeedBomAssociationTypeId]
		, [SpeedBomAssociationTypeName]
		, [SpeedBomAssociationTypeNameSpeed]
		, [SpeedBomAssociationTypeCodeSpeed]
	)
	SELECT
		  @Id -- [Id]
		, @Id -- [MMRecipeId]
		, [MATId]
		, [SpeedItemCategoryId]
		, [SpeedItemCategoryName]
		, [SpeedItemCategoryCode]
		, [ItemId]
		, [Revision]
		, [SpeedBomAssociationTypeId]
		, [SpeedBomAssociationTypeName]
		, [SpeedBomAssociationTypeNameSpeed]
		, [SpeedBomAssociationTypeCodeSpeed]
	FROM [qan].[FMMRecipeAssociatedItemsNewCore](@PCode);

	INSERT INTO @MATIds SELECT [MATId] FROM @AssociatedItems WHERE [MATId] IS NOT NULL;

	-- Output
	-- MM Recipe record
	SELECT * FROM @MMRecipe;

	-- NAND/Media items
	SELECT * FROM @AssociatedItems WHERE [SpeedItemCategoryCode] = 'NAND_MEDIA' ORDER BY [SpeedItemCategoryCode] ASC, [SpeedBomAssociationTypeName] DESC;
	-- NAND/Media MAT attribute values
	SELECT * FROM [qan].[FMATAttributeValues2](@MATIds) ORDER BY [MATAttributeTypeName], [Id];

	-- Other important associated items
	SELECT * FROM @AssociatedItems WHERE [SpeedItemCategoryCode] != 'NAND_MEDIA' ORDER BY [SpeedItemCategoryCode] ASC, [ItemId] ASC, [SpeedBomAssociationTypeName] DESC;

	-- The functions below will not filter on the product label id if the value is null; so set it to a non-existant id if it is null
	SET @ProductLabelId = ISNULL(@ProductLabelId, -1);

	-- Product label
	SELECT * FROM [qan].[FProductLabels](@ProductLabelId, NULL) ORDER BY [Id];

	-- Product label attributes
	SELECT * FROM [qan].[FProductLabelAttributes](NULL, @ProductLabelId, NULL) ORDER BY [Id];

END
