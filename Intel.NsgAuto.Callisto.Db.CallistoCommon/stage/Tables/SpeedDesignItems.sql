CREATE TABLE [stage].[SpeedDesignItems] (
    [ItemId]                       NVARCHAR (21)  NOT NULL,
    [ConnectorDesignatorCode]      NVARCHAR (255) NULL,
    [DesignedFunctionCode]         NVARCHAR (255) NULL,
    [DieArchitectureCode]          NVARCHAR (255) NULL,
    [FabCode]                      NVARCHAR (255) NULL,
    [FabProcess]                   NVARCHAR (255) NULL,
    [LrpEstimatedCacheQuantity]    NVARCHAR (255) NULL,
    [LrpEstimatedCacheUomCode]     NVARCHAR (255) NULL,
    [DieCodeName]                  NVARCHAR (255) NULL,
    [MemoryType1]                  NVARCHAR (255) NULL,
    [NomenclatureProgramLevelCode] NVARCHAR (255) NULL,
    [NomenclatureProgramScopeCode] NVARCHAR (255) NULL,
    [OldMaterialNbr]               NVARCHAR (255) NULL,
    [PlanningIgnoredIndicator]     NVARCHAR (255) NULL,
    [ProductLine]                  NVARCHAR (255) NULL,
    [FabDotProcess]                NVARCHAR (255) NULL,
    [Density]                      NVARCHAR (255) NULL,
    [DensityUom]                   NVARCHAR (255) NULL,
    [MfgDevice]                    NVARCHAR (255) NULL,
    [MfgStage]                     NVARCHAR (255) NULL,
    [Rev]                          NVARCHAR (255) NULL,
    [InternalStep]                 NVARCHAR (255) NULL,
    [RequestDate]                  NVARCHAR (255) NULL,
    [SubassyProdEngnrCd]           NVARCHAR (255) NULL,
    [WaferSize]                    NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ItemId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_MemoryType1]
    ON [stage].[SpeedDesignItems]([MemoryType1] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DieCodeName]
    ON [stage].[SpeedDesignItems]([DieCodeName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DieArchitectureCode]
    ON [stage].[SpeedDesignItems]([DieArchitectureCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DesignedFunctionCode]
    ON [stage].[SpeedDesignItems]([DesignedFunctionCode] ASC);

