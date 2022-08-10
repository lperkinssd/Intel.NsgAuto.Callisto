CREATE TABLE [qan].[OdmLotShipSnapshots] (
    [Version]              INT           NOT NULL,
    [location_type]        VARCHAR (255) NULL,
    [mm_number]            VARCHAR (255) NULL,
    [media_lot_id]         VARCHAR (255) NOT NULL,
    [description]          VARCHAR (255) NULL,
    [design_id]            VARCHAR (255) NULL,
    [device]               VARCHAR (50)  NULL,
    [number_of_die_in_pkg] INT           NULL,
    [probe_program_rev]    VARCHAR (255) NULL,
    [major_probe_prog_rev] VARCHAR (255) NULL,
    [burn_tape_revision]   VARCHAR (255) NULL,
    [custom_testing_reqd]  VARCHAR (50)  NULL,
    [fab_excr_id]          VARCHAR (255) NULL,
    [lot_id]               VARCHAR (255) NOT NULL,
    [product_grade]        VARCHAR (50)  NULL,
    [prb_conv_id]          VARCHAR (255) NULL,
    [reticle_wave_id]      VARCHAR (50)  NULL,
    [cell_revision]        VARCHAR (50)  NULL,
    [cmos_revision]        VARCHAR (50)  NULL,
    [fab_conv_id]          VARCHAR (50)  NULL,
    [shipping_label_lot]   VARCHAR (255) NULL
);








GO
CREATE NONCLUSTERED INDEX [IX_IOG_OdmLotShipSnapshots]
    ON [qan].[OdmLotShipSnapshots]([Version] DESC);

