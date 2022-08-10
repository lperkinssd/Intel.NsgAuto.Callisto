CREATE TABLE [stage].[SpeedPCodeItems] (
    [ItemId]                      NVARCHAR (21)  NOT NULL,
    [BatteryHazmatComplianceCode] NVARCHAR (255) NULL,
    [ExternalProductId]           NVARCHAR (255) NULL,
    [PbFreeCompatible]            NVARCHAR (255) NULL,
    [MarketCodeName]              NVARCHAR (255) NULL,
    [BrandedProductIndicator]     NVARCHAR (255) NULL,
    [BusArchitecture]             NVARCHAR (255) NULL,
    [DieCodeName]                 NVARCHAR (255) NULL,
    [CpuProcessorSpeed]           NVARCHAR (255) NULL,
    [CustomerCustomProduct]       NVARCHAR (255) NULL,
    [CustomIndicator]             NVARCHAR (255) NULL,
    [EncryptionCodeName]          NVARCHAR (255) NULL,
    [Encryption]                  NVARCHAR (255) NULL,
    [FormFactor]                  NVARCHAR (255) NULL,
    [FtoAllocFreeStock]           NVARCHAR (255) NULL,
    [RoyaltyReceivable]           NVARCHAR (255) NULL,
    [IntelInsideIndicator]        NVARCHAR (255) NULL,
    [ItemMarketName]              NVARCHAR (255) NULL,
    [MemoryAmount1]               NVARCHAR (255) NULL,
    [MemoryType1]                 NVARCHAR (255) NULL,
    [MemoryAmount2]               NVARCHAR (255) NULL,
    [MemoryType2]                 NVARCHAR (255) NULL,
    [PlanningSystem]              NVARCHAR (255) NULL,
    [BdCategoryType]              NVARCHAR (255) NULL,
    [ProductVisibility]           NVARCHAR (255) NULL,
    [RoyaltyPayable]              NVARCHAR (255) NULL,
    [ShipmentMedia]               NVARCHAR (255) NULL,
    [SosDefault]                  NVARCHAR (255) NULL,
    [SpecCode]                    NVARCHAR (255) NULL,
    [SpecSequentialNumber]        NVARCHAR (255) NULL,
    [TrademarkName]               NVARCHAR (255) NULL,
    [ModelStringName]             NVARCHAR (255) NULL,
    [NandLithographyThknsText]    NVARCHAR (255) NULL,
    [OldMaterialNbr]              NVARCHAR (255) NULL,
    [BitsPerCell]                 NVARCHAR (255) NULL,
    [PbFree]                      NVARCHAR (255) NULL,
    [VerticalSegment]             NVARCHAR (255) NULL,
    [UnderfillInd]                NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ItemId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_ModelStringName]
    ON [stage].[SpeedPCodeItems]([ModelStringName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ItemMarketName]
    ON [stage].[SpeedPCodeItems]([ItemMarketName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DieCodeName]
    ON [stage].[SpeedPCodeItems]([DieCodeName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MarketCodeName]
    ON [stage].[SpeedPCodeItems]([MarketCodeName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ExternalProductId]
    ON [stage].[SpeedPCodeItems]([ExternalProductId] ASC);

