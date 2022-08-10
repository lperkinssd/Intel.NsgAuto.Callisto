-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-16 09:43:55.417
-- Description  : Type used for comparing MM Recipes' associated item records together. The
--                comparison is based on PCode and ItemId so they are the primary key.
-- ================================================================================================
CREATE TYPE [qan].[IMMRecipeAssociatedItemsCompare] AS TABLE
(
	  [PCode]                      VARCHAR(10) NOT NULL
	, [ItemId]                     VARCHAR(21) NOT NULL
	, [Id]                         BIGINT
	, [MATId]                      INT
	, [SpeedItemCategoryId]        INT
	, [Revision]                   VARCHAR(2)
	, [SpeedBomAssociationTypeId]  INT
	, PRIMARY KEY ([PCode], [ItemId])
);
