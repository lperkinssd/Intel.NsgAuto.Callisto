CREATE TABLE [stage].[ItemDetailV2] (
    [PullDateTime]                    DATETIME        NOT NULL,
    [ItemId]                          NVARCHAR (21)   NOT NULL,
    [ItemDsc]                         NVARCHAR (127)  NULL,
    [ItemFullDsc]                     NVARCHAR (256)  NULL,
    [CommodityCd]                     NCHAR (10)      NULL,
    [ItemClassNm]                     NVARCHAR (18)   NULL,
    [ItemRevisionId]                  NCHAR (2)       NULL,
    [EffectiveRevisionCd]             NCHAR (2)       NULL,
    [CurrentRevisionCd]               NCHAR (2)       NULL,
    [ItemOwningSystemNm]              NCHAR (3)       NULL,
    [MakeBuyNm]                       NVARCHAR (20)   NULL,
    [NetWeightQty]                    NUMERIC (12, 5) NULL,
    [UnitOfMeasureCd]                 NCHAR (3)       NULL,
    [MaterialTypeCd]                  NCHAR (4)       NULL,
    [GrossWeightQty]                  NUMERIC (12, 5) NULL,
    [UnitOfWeightDim]                 NCHAR (3)       NULL,
    [GlobalTradeIdentifierNbr]        NVARCHAR (18)   NULL,
    [BusinessUnitId]                  NCHAR (2)       NULL,
    [BusinessUnitNm]                  NCHAR (16)      NULL,
    [LastClassChangeDt]               DATETIME2 (7)   NULL,
    [OwningSystemLastModificationDtm] DATETIME2 (7)   NULL,
    [CreateAgentId]                   NVARCHAR (20)   NULL,
    [CreateDtm]                       DATETIME2 (7)   NULL,
    [ChangeAgentId]                   NVARCHAR (20)   NULL,
    [ChangeDtm]                       DATETIME2 (7)   NULL,
    PRIMARY KEY CLUSTERED ([ItemId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_MaterialTypeCd]
    ON [stage].[ItemDetailV2]([MaterialTypeCd] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ItemClassNm]
    ON [stage].[ItemDetailV2]([ItemClassNm] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CommodityCd]
    ON [stage].[ItemDetailV2]([CommodityCd] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ItemDsc]
    ON [stage].[ItemDetailV2]([ItemDsc] ASC);

