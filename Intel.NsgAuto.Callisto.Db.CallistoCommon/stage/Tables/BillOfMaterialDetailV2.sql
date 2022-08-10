CREATE TABLE [stage].[BillOfMaterialDetailV2] (
    [PullDateTime]                    DATETIME        NOT NULL,
    [BillOfMaterialId]                INT             NULL,
    [ParentItemId]                    NVARCHAR (21)   NULL,
    [ChildItemId]                     NVARCHAR (21)   NULL,
    [ParentItemRevisionNbr]           NCHAR (2)       NULL,
    [ParentBusinessUnitId]            NCHAR (2)       NULL,
    [ParentBusinessUnitNm]            NCHAR (16)      NULL,
    [BillOfMaterialFindNbr]           SMALLINT        NULL,
    [BillOfMaterialAssociationTypeCd] NCHAR (1)       NULL,
    [BillOfMaterialAssociationTypeNm] NVARCHAR (255)  NULL,
    [BillOfMaterialStructureTypeNm]   NVARCHAR (127)  NULL,
    [ChildQty]                        NUMERIC (12, 5) NULL,
    [NoExplosionInd]                  NCHAR (1)       NULL,
    [CreateAgentId]                   NVARCHAR (20)   NULL,
    [CreateDtm]                       DATETIME2 (7)   NULL,
    [ChangeAgentId]                   NVARCHAR (20)   NULL,
    [ChangeDtm]                       DATETIME2 (7)   NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ChildItemId]
    ON [stage].[BillOfMaterialDetailV2]([ChildItemId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ParentItemId]
    ON [stage].[BillOfMaterialDetailV2]([ParentItemId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_BillOfMaterialId]
    ON [stage].[BillOfMaterialDetailV2]([BillOfMaterialId] ASC);

