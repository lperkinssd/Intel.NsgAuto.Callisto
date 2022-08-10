-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-22 11:30:34.387
-- Description  : This type should more or less stay in sync with the MMRecipeAssociatedItems
--                table. Do not put constraints (such as not null, primary key, etc.) in this type
--                due to how it is used, but indexes are okay.
-- ================================================================================================
CREATE TYPE [qan].[IMMRecipeAssociatedItems] AS TABLE
(
      [Id]                        BIGINT
    , [MMRecipeId]                BIGINT
    , [MATId]                     INT
    , [SpeedItemCategoryId]       INT
    , [ItemId]                    VARCHAR(21)
    , [Revision]                  VARCHAR(2)
    , [SpeedBomAssociationTypeId] INT
	, INDEX [IX_Id] ([Id])
	, INDEX [IX_MMRecipeId] ([MMRecipeId])
	, INDEX [IX_MATId] ([MATId])
);
