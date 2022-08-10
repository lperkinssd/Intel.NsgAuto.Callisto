CREATE TABLE [qan].[MMRecipeAssociatedItems]
(
      [Id]                        BIGINT IDENTITY (1, 1) NOT NULL
    , [MMRecipeId]                BIGINT NOT NULL
    , [MATId]                     INT NULL
    , [SpeedItemCategoryId]       INT NOT NULL
    , [ItemId]                    VARCHAR(21) NOT NULL
    , [Revision]                  VARCHAR(2)
    , [SpeedBomAssociationTypeId] INT
    CONSTRAINT [PK_MMRecipeAssociatedItems] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_MMRecipeAssociatedItems_MMRecipeId] ON [qan].[MMRecipeAssociatedItems] ([MMRecipeId])

GO

CREATE INDEX [IX_MMRecipeAssociatedItems_MATId] ON [qan].[MMRecipeAssociatedItems] ([MATId])

GO

CREATE INDEX [IX_MMRecipeAssociatedItems_ItemType] ON [qan].[MMRecipeAssociatedItems] ([SpeedItemCategoryId])

GO

CREATE INDEX [IX_MMRecipeAssociatedItems_ItemId] ON [qan].[MMRecipeAssociatedItems] ([ItemId])

GO

CREATE INDEX [IX_MMRecipeAssociatedItems_SpeedBomAssociationTypeId] ON [qan].[MMRecipeAssociatedItems] ([SpeedBomAssociationTypeId])
