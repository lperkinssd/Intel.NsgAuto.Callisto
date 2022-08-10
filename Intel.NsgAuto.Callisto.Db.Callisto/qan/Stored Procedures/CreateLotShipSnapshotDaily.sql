



-- =============================================
-- Author:		jakemurx
-- Create date: 2021-02-24 14:08:36.027
-- Description:	Create the latest [qan].[LotShipSnapshots] 
--              from [CallistoCommon].[stage].[lot_ship]
--              and the latest MAT and PRF imports
-- Note:        This must be called after [qan].[CreateOdmWipSnapshot2]
--              since [qan].[CreateLotShipSnapshot2] is dependent on the
--              latest version of [qan].[OdmWipSnapshots] 
-- =============================================
CREATE PROCEDURE [qan].[CreateLotShipSnapshotDaily]
	-- Add the parameters for the stored procedure here
	  @CountInserted INT = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Count INT;
	DECLARE @WipVersion INT = (SELECT Top 1 [Version] FROM [qan].[OdmWipSnapshots] ORDER BY [Version] DESC);
	DECLARE @Version INT = (SELECT Top 1 [Version] FROM [qan].[LotShipSnapshots] ORDER BY [Version] DESC);

	SET @CountInserted = 0;

	IF @Version IS NULL
		SET @Version = 0;


	IF OBJECT_ID('tempdb..#lot_ship_staging') IS NOT NULL  DROP TABLE #lot_ship_staging;
	IF OBJECT_ID('tempdb..#lot_ship') IS NOT NULL  DROP TABLE #lot_ship

	SELECT ls.* INTO #lot_ship_staging
	FROM [CallistoCommon].[stage].[lot_ship] ls WITH (NOLOCK)
	INNER JOIN [qan].[OdmWipSnapshots] owip WITH (NOLOCK)
	ON owip.media_lot_id = ls.lot_id
	WHERE owip.[Version] = @WipVersion
	AND ls.location_type='TST'

	INSERT INTO #lot_ship_staging
	SELECT ls.*
	FROM [CallistoCommon].[stage].[lot_ship] ls WITH (NOLOCK)
	INNER JOIN [qan].[OdmWipSnapshots] owip WITH (NOLOCK)
	ON owip.media_lot_id = ls.shipping_label_lot
	WHERE owip.[Version] = @WipVersion
	AND ls.location_type='TST'

	CREATE TABLE #lot_ship(
		[id] [uniqueidentifier] NOT NULL,
		[location_type] [varchar](255) NULL,
		[way_bill] [varchar](255) NULL,
		[mm_number] [varchar](50) NULL,
		[description] [varchar](50) NULL,
		[to_facility] [varchar](255) NULL,
		[invoice] [varchar](50) NULL,
		[delivery_note] [varchar](1000) NULL,
		[intel_box] [varchar](50) NULL,
		[unit_qty] [int] NULL,
		[po] [varchar](50) NULL,
		[intel_upi] [varchar](50) NULL,
		[design_id] [varchar](255) NULL,
		[device] [varchar](50) NULL,
		[number_of_die_in_pkg] [int] NULL,
		[probe_program_rev] [varchar](255) NULL,
		[major_probe_prog_rev] [varchar](255) NULL,
		[fabrication_facility] [varchar](255) NULL,
		[app_restriction] [varchar](255) NULL,
		[apo_number] [varchar](255) NULL,
		[die_qty] [int] NULL,
		[custom_tested] [varchar](50) NULL,
		[intel_reclaim] [varchar](50) NULL,
		[alternate_speed_sort] [varchar](50) NULL,
		[ate_tape_revision] [varchar](255) NULL,
		[burn_experiment] [varchar](255) NULL,
		[burn_flow] [varchar](50) NULL,
		[burn_tape_revision] [varchar](255) NULL,
		[wafer_qty] [int] NULL,
		[custom_testing_reqd] [varchar](50) NULL,
		[ddp_ineligible] [varchar](255) NULL,
		[disallow_merging] [varchar](255) NULL,
		[eng_master_version] [varchar](50) NULL,
		[fab_excr_id] [varchar](255) NULL,
		[future_hold_location] [varchar](255) NULL,
		[hdp_ineligible] [varchar](255) NULL,
		[hold_for_whom] [varchar](255) NULL,
		[hold_lot] [varchar](255) NULL,
		[hold_notes] [varchar](1000) NULL,
		[hold_reason] [varchar](255) NULL,
		[hot_lot_priority] [varchar](50) NULL,
		[intel_ship_pass1_qty] [int] NULL,
		[intel_ship_pass2_qty] [int] NULL,
		[intel_ship_pass3_qty] [int] NULL,
		[intel_ship_pass4_qty] [int] NULL,
		[inventory_location] [varchar](255) NULL,
		[lot_has_been_marked] [varchar](50) NULL,
		[lot_has_rejects] [varchar](50) NULL,
		[lot_id] [varchar](50) NOT NULL,
		[marketing_speed] [varchar](50) NULL,
		[non_shippable] [varchar](255) NULL,
		[num_array_decks] [int] NULL,
		[odp_ineligible] [varchar](255) NULL,
		[planned_laser_scribe] [varchar](50) NULL,
		[planned_test_site] [varchar](50) NULL,
		[product_grade_sorted] [varchar](50) NULL,
		[prod_grade_sort_reqd] [varchar](50) NULL,
		[product_grade] [varchar](50) NULL,
		[qa_asm_conv_hold] [varchar](255) NULL,
		[qa_asm_excr_hold] [varchar](255) NULL,
		[qa_asm_swr_hold] [varchar](255) NULL,
		[qa_disposition_hold] [varchar](255) NULL,
		[qa_fab_conv_hold] [varchar](255) NULL,
		[qa_fab_excr_hold] [varchar](255) NULL,
		[qa_fab_swr_hold] [varchar](255) NULL,
		[qa_prb_conv_hold] [varchar](255) NULL,
		[qa_prb_excr_hold] [varchar](255) NULL,
		[qa_reticle_wave_hold] [varchar](255) NULL,
		[qa_work_request_desc] [varchar](255) NULL,
		[qdp_ineligible] [varchar](50) NULL,
		[test_data_reqd] [varchar](50) NULL,
		[prb_conv_id] [varchar](255) NULL,
		[num_io_channels] [int] NULL,
		[reticle_wave_id] [varchar](50) NULL,
		[cell_revision] [varchar](50) NULL,
		[cmos_revision] [varchar](50) NULL,
		[cold_final_reqd] [varchar](50) NULL,
		[excr_containment] [varchar](255) NULL,
		[lead_count] [varchar](50) NULL,
		[num_flash_ce_pins] [varchar](50) NULL,
		[country_of_assembly] [varchar](50) NULL,
		[last_updated_datetime] [datetime] NOT NULL,
		[last_tracked_source] [varchar](255) NOT NULL,
		[load_file_datetime] [datetime] NOT NULL,
		[current_location] [varchar](50) NOT NULL,
		[shipment_date] [datetime] NULL,
		[shipping_label_lot] [varchar](50) NULL,
		[fab_conv_id] [varchar](50) NULL,
		[unqualified] [varchar](50) NULL,
		[elec_special_test] [varchar](50) NULL,
		[rma_lot] [varchar](50) NULL,
		[cibr_lot_number] [varchar](50) NULL,
		[intel_ship_pass5_qty][int] NULL,
		[intel_ship_pass6_qty][int] NULL
	)

	INSERT INTO #lot_ship
	SELECT [id]
		,[location_type]
		,[way_bill]
		,[mm_number]
		,[description]
		,[to_facility]
		,[invoice]
		,[delivery_note]
		,[intel_box]
		,[unit_qty]
		,[po]
		,[intel_upi]
		,[design_id]
		,[device]
		,[number_of_die_in_pkg]
		,[probe_program_rev]
		,[major_probe_prog_rev]
		,[fabrication_facility]
		,[app_restriction]
		,[apo_number]
		,[die_qty]
		,[custom_tested]
		,[intel_reclaim]
		,[alternate_speed_sort]
		,[ate_tape_revision]
		,[burn_experiment]
		,[burn_flow]
		,[burn_tape_revision]
		,[wafer_qty]
		,[custom_testing_reqd]
		,[ddp_ineligible]
		,[disallow_merging]
		,[eng_master_version]
		,[fab_excr_id]
		,[future_hold_location]
		,[hdp_ineligible]
		,[hold_for_whom]
		,[hold_lot]
		,[hold_notes]
		,[hold_reason]
		,[hot_lot_priority]
		,[intel_ship_pass1_qty]
		,[intel_ship_pass2_qty]
		,[intel_ship_pass3_qty]
		,[intel_ship_pass4_qty]
		,[inventory_location]
		,[lot_has_been_marked]
		,[lot_has_rejects]
		,[lot_id]
		,[marketing_speed]
		,[non_shippable]
		,[num_array_decks]
		,[odp_ineligible]
		,[planned_laser_scribe]
		,[planned_test_site]
		,[product_grade_sorted]
		,[prod_grade_sort_reqd]
		,[product_grade]
		,[qa_asm_conv_hold]
		,[qa_asm_excr_hold]
		,[qa_asm_swr_hold]
		,[qa_disposition_hold]
		,[qa_fab_conv_hold]
		,[qa_fab_excr_hold]
		,[qa_fab_swr_hold]
		,[qa_prb_conv_hold]
		,[qa_prb_excr_hold]
		,[qa_reticle_wave_hold]
		,[qa_work_request_desc]
		,[qdp_ineligible]
		,[test_data_reqd]
		,[prb_conv_id]
		,[num_io_channels]
		,[reticle_wave_id]
		,[cell_revision]
		,[cmos_revision]
		,[cold_final_reqd]
		,[excr_containment]
		,[lead_count]
		,[num_flash_ce_pins]
		,[country_of_assembly]
		,[last_updated_datetime]
		,[last_tracked_source]
		,[load_file_datetime]
		,[current_location]
		,[shipment_date]
		,[shipping_label_lot]
		,[fab_conv_id]
		,[unqualified]
		,[elec_special_test]
		,[rma_lot]
		,[cibr_lot_number]
		,[intel_ship_pass5_qty]
		,[intel_ship_pass6_qty]
	FROM #lot_ship_staging
	EXCEPT
	SELECT [id]
		,[location_type]
		,[way_bill]
		,[mm_number]
		,[description]
		,[to_facility]
		,[invoice]
		,[delivery_note]
		,[intel_box]
		,[unit_qty]
		,[po]
		,[intel_upi]
		,[design_id]
		,[device]
		,[number_of_die_in_pkg]
		,[probe_program_rev]
		,[major_probe_prog_rev]
		,[fabrication_facility]
		,[app_restriction]
		,[apo_number]
		,[die_qty]
		,[custom_tested]
		,[intel_reclaim]
		,[alternate_speed_sort]
		,[ate_tape_revision]
		,[burn_experiment]
		,[burn_flow]
		,[burn_tape_revision]
		,[wafer_qty]
		,[custom_testing_reqd]
		,[ddp_ineligible]
		,[disallow_merging]
		,[eng_master_version]
		,[fab_excr_id]
		,[future_hold_location]
		,[hdp_ineligible]
		,[hold_for_whom]
		,[hold_lot]
		,[hold_notes]
		,[hold_reason]
		,[hot_lot_priority]
		,[intel_ship_pass1_qty]
		,[intel_ship_pass2_qty]
		,[intel_ship_pass3_qty]
		,[intel_ship_pass4_qty]
		,[inventory_location]
		,[lot_has_been_marked]
		,[lot_has_rejects]
		,[lot_id]
		,[marketing_speed]
		,[non_shippable]
		,[num_array_decks]
		,[odp_ineligible]
		,[planned_laser_scribe]
		,[planned_test_site]
		,[product_grade_sorted]
		,[prod_grade_sort_reqd]
		,[product_grade]
		,[qa_asm_conv_hold]
		,[qa_asm_excr_hold]
		,[qa_asm_swr_hold]
		,[qa_disposition_hold]
		,[qa_fab_conv_hold]
		,[qa_fab_excr_hold]
		,[qa_fab_swr_hold]
		,[qa_prb_conv_hold]
		,[qa_prb_excr_hold]
		,[qa_reticle_wave_hold]
		,[qa_work_request_desc]
		,[qdp_ineligible]
		,[test_data_reqd]
		,[prb_conv_id]
		,[num_io_channels]
		,[reticle_wave_id]
		,[cell_revision]
		,[cmos_revision]
		,[cold_final_reqd]
		,[excr_containment]
		,[lead_count]
		,[num_flash_ce_pins]
		,[country_of_assembly]
		,[last_updated_datetime]
		,[last_tracked_source]
		,[load_file_datetime]
		,[current_location]
		,[shipment_date]
		,[shipping_label_lot]
		,[fab_conv_id]
		,[unqualified]
		,[elec_special_test]
		,[rma_lot]
		,[cibr_lot_number]
		,[intel_ship_pass5_qty]
		,[intel_ship_pass6_qty]
	FROM [qan].[LotShipSnapshots] WITH (NOLOCK)
	WHERE [Version] = @Version

	SELECT @Count = COUNT(*) FROM #lot_ship;

	IF @Count > 0
	BEGIN
	
		-- Get the next Version number
		SET @Version = @Version + 1;

		INSERT INTO [qan].[LotShipSnapshots]
		SELECT @Version
			,[id]
			,[location_type]
			,[way_bill]
			,[mm_number]
			,[description]
			,[to_facility]
			,[invoice]
			,[delivery_note]
			,[intel_box]
			,[unit_qty]
			,[po]
			,[intel_upi]
			,[design_id]
			,[device]
			,[number_of_die_in_pkg]
			,[probe_program_rev]
			,[major_probe_prog_rev]
			,[fabrication_facility]
			,[app_restriction]
			,[apo_number]
			,[die_qty]
			,[custom_tested]
			,[intel_reclaim]
			,[alternate_speed_sort]
			,[ate_tape_revision]
			,[burn_experiment]
			,[burn_flow]
			,[burn_tape_revision]
			,[wafer_qty]
			,[custom_testing_reqd]
			,[ddp_ineligible]
			,[disallow_merging]
			,[eng_master_version]
			,[fab_excr_id]
			,[future_hold_location]
			,[hdp_ineligible]
			,[hold_for_whom]
			,[hold_lot]
			,[hold_notes]
			,[hold_reason]
			,[hot_lot_priority]
			,[intel_ship_pass1_qty]
			,[intel_ship_pass2_qty]
			,[intel_ship_pass3_qty]
			,[intel_ship_pass4_qty]
			,[inventory_location]
			,[lot_has_been_marked]
			,[lot_has_rejects]
			,[lot_id]
			,[marketing_speed]
			,[non_shippable]
			,[num_array_decks]
			,[odp_ineligible]
			,[planned_laser_scribe]
			,[planned_test_site]
			,[product_grade_sorted]
			,[prod_grade_sort_reqd]
			,[product_grade]
			,[qa_asm_conv_hold]
			,[qa_asm_excr_hold]
			,[qa_asm_swr_hold]
			,[qa_disposition_hold]
			,[qa_fab_conv_hold]
			,[qa_fab_excr_hold]
			,[qa_fab_swr_hold]
			,[qa_prb_conv_hold]
			,[qa_prb_excr_hold]
			,[qa_reticle_wave_hold]
			,[qa_work_request_desc]
			,[qdp_ineligible]
			,[test_data_reqd]
			,[prb_conv_id]
			,[num_io_channels]
			,[reticle_wave_id]
			,[cell_revision]
			,[cmos_revision]
			,[cold_final_reqd]
			,[excr_containment]
			,[lead_count]
			,[num_flash_ce_pins]
			,[country_of_assembly]
			,[last_updated_datetime]
			,[last_tracked_source]
			,[load_file_datetime]
			,[current_location]
			,[shipment_date]
			,[shipping_label_lot]
			,[fab_conv_id]
			,[unqualified]
			,[elec_special_test]
			,[rma_lot]
			,[cibr_lot_number]
			,[intel_ship_pass5_qty]
			,[intel_ship_pass6_qty]
		FROM  #lot_ship_staging

		SELECT @CountInserted = COUNT(*) FROM #lot_ship_staging;
	END
END