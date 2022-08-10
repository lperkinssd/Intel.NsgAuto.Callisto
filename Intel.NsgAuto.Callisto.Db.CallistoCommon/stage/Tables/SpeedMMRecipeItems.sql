CREATE TABLE [stage].[SpeedMMRecipeItems] (
    [RootItemId]      NVARCHAR (21)  NULL,
    [ItemCategory]    VARCHAR (10)   NULL,
    [ItemId]          NVARCHAR (21)  NULL,
    [Revision]        NCHAR (2)      NULL,
    [AssociationType] NVARCHAR (255) NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_AssociationType]
    ON [stage].[SpeedMMRecipeItems]([AssociationType] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ItemId]
    ON [stage].[SpeedMMRecipeItems]([ItemId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ItemCategory]
    ON [stage].[SpeedMMRecipeItems]([ItemCategory] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RootItemId]
    ON [stage].[SpeedMMRecipeItems]([RootItemId] ASC);

