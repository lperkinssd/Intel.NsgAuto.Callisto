CREATE TABLE [stage].[odm_wip_data] (
    [media_lot_id]       VARCHAR (50) NOT NULL,
    [subcon_name]        VARCHAR (50) NOT NULL,
    [intel_part_number]  VARCHAR (50) NOT NULL,
    [location_type]      VARCHAR (50) NOT NULL,
    [inventory_location] VARCHAR (50) NOT NULL,
    [category]           VARCHAR (50) NOT NULL,
    [mm_number]          VARCHAR (50) NOT NULL,
    [time_entered]       DATETIME     NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_mm_number]
    ON [stage].[odm_wip_data]([mm_number] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_category]
    ON [stage].[odm_wip_data]([category] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_inventory_location]
    ON [stage].[odm_wip_data]([inventory_location] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_location_type]
    ON [stage].[odm_wip_data]([location_type] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_intel_part_number]
    ON [stage].[odm_wip_data]([intel_part_number] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_subcon_name]
    ON [stage].[odm_wip_data]([subcon_name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_media_lot_id]
    ON [stage].[odm_wip_data]([media_lot_id] ASC);

