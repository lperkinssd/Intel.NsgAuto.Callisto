-- ===============================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-06 16:50:06.293
-- Description  : Generates the core associated items part of a new MM recipe for the given PCode
-- Example      : SELECT * FROM [qan].[FMMRecipeAssociatedItemsNewCore]('980315');
-- ===============================================================================================
CREATE FUNCTION [qan].[FMMRecipeAssociatedItemsNewCore]
(
	  @PCode VARCHAR(10)
)
RETURNS @Result TABLE
(
	  [MATId]                             INT
	, [SpeedItemCategoryId]               INT
	, [SpeedItemCategoryName]             VARCHAR(50)
	, [SpeedItemCategoryCode]             VARCHAR(25)
	, [ItemId]                            VARCHAR(21)
	, [Revision]                          VARCHAR(2)
	, [SpeedBomAssociationTypeId]         INT
	, [SpeedBomAssociationTypeName]       VARCHAR(20)
	, [SpeedBomAssociationTypeNameSpeed]  VARCHAR(20)
	, [SpeedBomAssociationTypeCodeSpeed]  VARCHAR(1)
)
AS
BEGIN

	DECLARE @PCodes [qan].[IPCodes];
	INSERT INTO @PCodes VALUES (@PCode);

	INSERT INTO @Result
	SELECT
		  [MATId]
		, [SpeedItemCategoryId]
		, [SpeedItemCategoryName]
		, [SpeedItemCategoryCode]
		, [ItemId]
		, [Revision]
		, [SpeedBomAssociationTypeId]
		, [SpeedBomAssociationTypeName]
		, [SpeedBomAssociationTypeNameSpeed]
		, [SpeedBomAssociationTypeCodeSpeed]
	FROM [qan].[FMMRecipesAssociatedItemsNewCore](@PCodes);

	RETURN;

END
