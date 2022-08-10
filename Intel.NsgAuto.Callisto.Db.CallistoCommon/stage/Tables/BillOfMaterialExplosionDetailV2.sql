CREATE TABLE [stage].[BillOfMaterialExplosionDetailV2] (
    [PullDateTime]                    DATETIME       NOT NULL,
    [@ItemId]                         NVARCHAR (21)  NULL,
    [RootItemId]                      NVARCHAR (21)  NULL,
    [RootItemRevisionNbr]             NCHAR (2)      NULL,
    [BillOfMaterialLevelNbr]          INT            NULL,
    [ParentBillOfMaterialRowNbr]      INT            NULL,
    [BillOfMaterialRowNbr]            INT            NULL,
    [ParentItemId]                    NVARCHAR (21)  NULL,
    [ParentItemRevisionNbr]           NCHAR (2)      NULL,
    [ChildItemId]                     NVARCHAR (21)  NULL,
    [ChildItemRevisionNbr]            NCHAR (2)      NULL,
    [ItemDsc]                         NVARCHAR (127) NULL,
    [ReleaseStatusCd]                 NCHAR (1)      NULL,
    [ReleaseStatusNm]                 NVARCHAR (16)  NULL,
    [ItemRevisionCreateDtm]           DATETIME2 (7)  NULL,
    [ChildQuantityRequiredNbr]        FLOAT (53)     NULL,
    [UnitOfMeasureCd]                 NCHAR (3)      NULL,
    [UnitOfWeightCd]                  NCHAR (3)      NULL,
    [BillOfMaterialFindNbr]           SMALLINT       NULL,
    [BillOfMaterialTypeCd]            NCHAR (1)      NULL,
    [BillOfMaterialAssociationTypeNm] NVARCHAR (255) NULL,
    [BillOfMaterialStructureTypeNm]   NVARCHAR (127) NULL,
    [CommodityCd]                     NCHAR (10)     NULL,
    [CommodityCodeDsc]                NVARCHAR (40)  NULL,
    [MaterialTypeCd]                  NCHAR (4)      NULL,
    [ItemTypeCd]                      NCHAR (4)      NULL,
    [ItemClassDsc]                    NVARCHAR (18)  NULL,
    [ItemRevisionProjectCd]           NVARCHAR (15)  NULL,
    [BusinessUnitId]                  NCHAR (2)      NULL,
    [BusinessUnitNm]                  NCHAR (16)     NULL,
    [MakeBuyNm]                       NVARCHAR (20)  NULL,
    [SortOrderNbr]                    NVARCHAR (255) NULL,
    [NoExplosionInd]                  NVARCHAR (1)   NULL,
    [CreateAgentId]                   NVARCHAR (20)  NULL,
    [CreateDtm]                       DATETIME2 (7)  NULL,
    [ChangeAgentId]                   NVARCHAR (20)  NULL,
    [ChangeDtm]                       DATETIME2 (7)  NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ChildItemId]
    ON [stage].[BillOfMaterialExplosionDetailV2]([ChildItemId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ParentItemId]
    ON [stage].[BillOfMaterialExplosionDetailV2]([ParentItemId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ItemId]
    ON [stage].[BillOfMaterialExplosionDetailV2]([@ItemId] ASC);

