CREATE TABLE [qan].[lot_ship_staging] (
    [id]                    UNIQUEIDENTIFIER NOT NULL,
    [location_type]         VARCHAR (255)    NULL,
    [way_bill]              VARCHAR (255)    NULL,
    [mm_number]             VARCHAR (50)     NULL,
    [description]           VARCHAR (50)     NULL,
    [to_facility]           VARCHAR (255)    NULL,
    [invoice]               VARCHAR (50)     NULL,
    [delivery_note]         VARCHAR (1000)   NULL,
    [intel_box]             VARCHAR (50)     NULL,
    [unit_qty]              INT              NULL,
    [po]                    VARCHAR (50)     NULL,
    [intel_upi]             VARCHAR (50)     NULL,
    [design_id]             VARCHAR (255)    NULL,
    [device]                VARCHAR (50)     NULL,
    [number_of_die_in_pkg]  INT              NULL,
    [probe_program_rev]     VARCHAR (255)    NULL,
    [major_probe_prog_rev]  VARCHAR (255)    NULL,
    [fabrication_facility]  VARCHAR (255)    NULL,
    [app_restriction]       VARCHAR (255)    NULL,
    [apo_number]            VARCHAR (255)    NULL,
    [die_qty]               INT              NULL,
    [custom_tested]         VARCHAR (50)     NULL,
    [intel_reclaim]         VARCHAR (50)     NULL,
    [alternate_speed_sort]  VARCHAR (50)     NULL,
    [ate_tape_revision]     VARCHAR (255)    NULL,
    [burn_experiment]       VARCHAR (255)    NULL,
    [burn_flow]             VARCHAR (50)     NULL,
    [burn_tape_revision]    VARCHAR (255)    NULL,
    [wafer_qty]             INT              NULL,
    [custom_testing_reqd]   VARCHAR (50)     NULL,
    [ddp_ineligible]        VARCHAR (255)    NULL,
    [disallow_merging]      VARCHAR (255)    NULL,
    [eng_master_version]    VARCHAR (50)     NULL,
    [fab_excr_id]           VARCHAR (255)    NULL,
    [future_hold_location]  VARCHAR (255)    NULL,
    [hdp_ineligible]        VARCHAR (255)    NULL,
    [hold_for_whom]         VARCHAR (255)    NULL,
    [hold_lot]              VARCHAR (255)    NULL,
    [hold_notes]            VARCHAR (1000)   NULL,
    [hold_reason]           VARCHAR (255)    NULL,
    [hot_lot_priority]      VARCHAR (50)     NULL,
    [intel_ship_pass1_qty]  INT              NULL,
    [intel_ship_pass2_qty]  INT              NULL,
    [intel_ship_pass3_qty]  INT              NULL,
    [intel_ship_pass4_qty]  INT              NULL,
    [inventory_location]    VARCHAR (255)    NULL,
    [lot_has_been_marked]   VARCHAR (50)     NULL,
    [lot_has_rejects]       VARCHAR (50)     NULL,
    [lot_id]                VARCHAR (50)     NOT NULL,
    [marketing_speed]       VARCHAR (50)     NULL,
    [non_shippable]         VARCHAR (255)    NULL,
    [num_array_decks]       INT              NULL,
    [odp_ineligible]        VARCHAR (255)    NULL,
    [planned_laser_scribe]  VARCHAR (50)     NULL,
    [planned_test_site]     VARCHAR (50)     NULL,
    [product_grade_sorted]  VARCHAR (50)     NULL,
    [prod_grade_sort_reqd]  VARCHAR (50)     NULL,
    [product_grade]         VARCHAR (50)     NULL,
    [qa_asm_conv_hold]      VARCHAR (255)    NULL,
    [qa_asm_excr_hold]      VARCHAR (255)    NULL,
    [qa_asm_swr_hold]       VARCHAR (255)    NULL,
    [qa_disposition_hold]   VARCHAR (255)    NULL,
    [qa_fab_conv_hold]      VARCHAR (255)    NULL,
    [qa_fab_excr_hold]      VARCHAR (255)    NULL,
    [qa_fab_swr_hold]       VARCHAR (255)    NULL,
    [qa_prb_conv_hold]      VARCHAR (255)    NULL,
    [qa_prb_excr_hold]      VARCHAR (255)    NULL,
    [qa_reticle_wave_hold]  VARCHAR (255)    NULL,
    [qa_work_request_desc]  VARCHAR (255)    NULL,
    [qdp_ineligible]        VARCHAR (50)     NULL,
    [test_data_reqd]        VARCHAR (50)     NULL,
    [prb_conv_id]           VARCHAR (255)    NULL,
    [num_io_channels]       INT              NULL,
    [reticle_wave_id]       VARCHAR (50)     NULL,
    [cell_revision]         VARCHAR (50)     NULL,
    [cmos_revision]         VARCHAR (50)     NULL,
    [cold_final_reqd]       VARCHAR (50)     NULL,
    [excr_containment]      VARCHAR (255)    NULL,
    [lead_count]            VARCHAR (50)     NULL,
    [num_flash_ce_pins]     VARCHAR (50)     NULL,
    [country_of_assembly]   VARCHAR (50)     NULL,
    [last_updated_datetime] DATETIME         NOT NULL,
    [last_tracked_source]   VARCHAR (255)    NOT NULL,
    [load_file_datetime]    DATETIME         NOT NULL,
    [current_location]      VARCHAR (50)     NOT NULL,
    [shipment_date]         DATETIME         NULL,
    [shipping_label_lot]    VARCHAR (50)     NULL,
    [fab_conv_id]           VARCHAR (50)     NULL,
    [unqualified]           VARCHAR (50)     NULL,
    [elec_special_test]     VARCHAR (50)     NULL,
    [rma_lot]               VARCHAR (50)     NULL,
    [cibr_lot_number]       VARCHAR (50)     NULL,
    [intel_ship_pass5_qty]  INT              NULL,
    [intel_ship_pass6_qty]  INT              NULL
);



