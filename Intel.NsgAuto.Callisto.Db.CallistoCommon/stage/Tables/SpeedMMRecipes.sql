CREATE TABLE [stage].[SpeedMMRecipes] (
    [RootItemId]            NVARCHAR (21)   NOT NULL,
    [PCode]                 NVARCHAR (21)   NULL,
    [PCodeRevision]         NCHAR (2)       NULL,
    [SCode]                 NVARCHAR (21)   NULL,
    [SCodeRevision]         NCHAR (2)       NULL,
    [ProductName]           NVARCHAR (1023) NULL,
    [ProductFamily]         NVARCHAR (255)  NULL,
    [ProductionProductCode] NVARCHAR (255)  NULL,
    [ModelString]           NVARCHAR (255)  NULL,
    [FormFactorName]        NVARCHAR (255)  NULL,
    [CustomerName]          NVARCHAR (255)  NULL,
    [SCodeProductCode]      NVARCHAR (255)  NULL,
    PRIMARY KEY CLUSTERED ([RootItemId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_SCodeProductCode]
    ON [stage].[SpeedMMRecipes]([SCodeProductCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CustomerName]
    ON [stage].[SpeedMMRecipes]([CustomerName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_FormFactorName]
    ON [stage].[SpeedMMRecipes]([FormFactorName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ModelString]
    ON [stage].[SpeedMMRecipes]([ModelString] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProductionProductCode]
    ON [stage].[SpeedMMRecipes]([ProductionProductCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProductFamily]
    ON [stage].[SpeedMMRecipes]([ProductFamily] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_SCode]
    ON [stage].[SpeedMMRecipes]([SCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_PCode]
    ON [stage].[SpeedMMRecipes]([PCode] ASC);

