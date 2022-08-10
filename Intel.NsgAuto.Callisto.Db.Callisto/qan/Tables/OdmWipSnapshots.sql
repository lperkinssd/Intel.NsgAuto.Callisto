CREATE TABLE [qan].[OdmWipSnapshots] (
    [Version]            INT           NOT NULL,
    [media_lot_id]       VARCHAR (255) NOT NULL,
    [subcon_name]        VARCHAR (255) NOT NULL,
    [intel_part_number]  VARCHAR (255) NULL,
    [location_type]      VARCHAR (255) NULL,
    [inventory_location] VARCHAR (255) NULL,
    [category]           VARCHAR (255) NULL,
    [mm_number]          VARCHAR (255) NULL,
    [time_entered]       DATETIME2 (7) NULL
);








GO



GO



GO
CREATE NONCLUSTERED INDEX [IX_IOG_OdmWipSnapshots_Version_Lot]
    ON [qan].[OdmWipSnapshots]([Version] ASC, [media_lot_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IOG_OdmWipSnapshots_Version_IPN]
    ON [qan].[OdmWipSnapshots]([Version] ASC, [intel_part_number] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IOG_OdmWipSnapshots]
    ON [qan].[OdmWipSnapshots]([Version] DESC);

