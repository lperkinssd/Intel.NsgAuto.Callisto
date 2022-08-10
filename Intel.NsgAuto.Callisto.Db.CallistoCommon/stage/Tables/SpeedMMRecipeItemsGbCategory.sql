CREATE TABLE [stage].[SpeedMMRecipeItemsGbCategory] (
    [RootItemId]         NVARCHAR (21)  NULL,
    [ItemCategory]       VARCHAR (10)   NULL,
    [MaxItemId]          NVARCHAR (21)  NULL,
    [MaxRevision]        NCHAR (2)      NULL,
    [MaxAssociationType] NVARCHAR (255) NULL,
    [Count]              INT            NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_MaxItemId]
    ON [stage].[SpeedMMRecipeItemsGbCategory]([MaxItemId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ItemCategory]
    ON [stage].[SpeedMMRecipeItemsGbCategory]([ItemCategory] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RootItemId]
    ON [stage].[SpeedMMRecipeItemsGbCategory]([RootItemId] ASC);

