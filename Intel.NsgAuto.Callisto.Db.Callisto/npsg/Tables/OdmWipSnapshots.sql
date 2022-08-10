CREATE TABLE [npsg].[OdmWipSnapshots] (
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
CREATE NONCLUSTERED INDEX [IX_NPSG_OdmWipSnapshots_Version_Lot]
    ON [npsg].[OdmWipSnapshots]([Version] ASC, [media_lot_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_NPSG_OdmWipSnapshots_Version_IPN]
    ON [npsg].[OdmWipSnapshots]([Version] ASC, [intel_part_number] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_NPSG_OdmWipSnapshots]
    ON [npsg].[OdmWipSnapshots]([Version] DESC);

