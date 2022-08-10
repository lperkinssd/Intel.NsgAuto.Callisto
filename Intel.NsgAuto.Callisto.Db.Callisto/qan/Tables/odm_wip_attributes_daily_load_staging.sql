CREATE TABLE [qan].[odm_wip_attributes_daily_load_staging] (
    [media_lot_id]       VARCHAR (255) NOT NULL,
    [subcon_name]        VARCHAR (255) NOT NULL,
    [intel_part_number]  VARCHAR (255) NULL,
    [location_type]      VARCHAR (255) NULL,
    [inventory_location] VARCHAR (255) NULL,
    [category]           VARCHAR (255) NULL,
    [mm_number]          VARCHAR (255) NULL,
    [time_entered]       DATETIME2 (7) NULL
);

