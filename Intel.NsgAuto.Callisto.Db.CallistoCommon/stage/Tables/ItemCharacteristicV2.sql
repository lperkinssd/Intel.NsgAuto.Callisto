CREATE TABLE [stage].[ItemCharacteristicV2] (
    [PullDateTime]                  DATETIME       NOT NULL,
    [ItemId]                        NVARCHAR (21)  NULL,
    [CharacteristicId]              SMALLINT       NULL,
    [CharacteristicNm]              NVARCHAR (30)  NULL,
    [CharacteristicDsc]             NVARCHAR (80)  NULL,
    [CharacteristicValueTxt]        NVARCHAR (255) NULL,
    [CharacteristicSequenceNbr]     INT            NULL,
    [CharacteristicLastModifiedDt]  DATETIME2 (7)  NULL,
    [CharacteristicLastModifiedUsr] NVARCHAR (40)  NULL,
    [CreateAgentId]                 NVARCHAR (20)  NULL,
    [CreateDtm]                     DATETIME2 (7)  NULL,
    [ChangeAgentId]                 NVARCHAR (20)  NULL,
    [ChangeDtm]                     DATETIME2 (7)  NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_CharacteristicNm]
    ON [stage].[ItemCharacteristicV2]([CharacteristicNm] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CharacteristicId]
    ON [stage].[ItemCharacteristicV2]([CharacteristicId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ItemId]
    ON [stage].[ItemCharacteristicV2]([ItemId] ASC);

