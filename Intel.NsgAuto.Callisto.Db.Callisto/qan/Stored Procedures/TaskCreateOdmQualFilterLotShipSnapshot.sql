-- ======================================================================================
-- Author      : jkurian (refactored by bricschx)
-- Create date : 2021-02-24 14:08:36.027
-- Description : Create records in [qan].[OdmLotShipSnapshots] from the latest data in
--               [TREADSTONEPRD].treadstone.[dbo].[lot_ship]
-- Note:         This must be called after [qan].[TaskCreateOdmQualFilterLotShipSnapshot]
--               due to dependency on [qan].[OdmWipSnapshots]. Copied and tweaked from
--               [qan].[CreateOdmLotShipSnapshotDaily]
-- Example     : EXEC [qan].[TaskCreateOdmQualFilterLotShipSnapshot];
-- ======================================================================================
CREATE PROCEDURE [qan].[TaskCreateOdmQualFilterLotShipSnapshot]
	  @CountInserted INT = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText  NVARCHAR(4000);
	DECLARE @TaskId       BIGINT;

	SET @CountInserted = 0;

	BEGIN TRY

		EXEC [CallistoCommon].[stage].[CreateTaskByName] @TaskId OUTPUT, 'Create ODM QF Lot Ship Snapshot';

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 0, 'Determining latest ODM WIP snapshot and ODM Lot Ship snapshot versions';

		DECLARE @Count       INT;
		DECLARE @WipVersion  INT = (SELECT MAX([Version]) FROM [qan].[OdmWipSnapshots]      WITH (NOLOCK));
		DECLARE @Version     INT = (SELECT MAX([Version]) FROM [qan].[OdmLotShipSnapshots]  WITH (NOLOCK));

		SET @MessageText = 'Versions determined; ODM WIP snapshot version = ' + ISNULL(CAST(@WipVersion AS VARCHAR(20)), '') + '; ODM Lot Ship snapshot version = ' + ISNULL(CAST(@Version AS VARCHAR(20)), '');
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		IF @Version IS NULL SET @Version = 0;

		IF OBJECT_ID('tempdb..#lot_ship_staging') IS NOT NULL  DROP TABLE #lot_ship_staging;
		IF OBJECT_ID('tempdb..#lot_ship') IS NOT NULL  DROP TABLE #lot_ship

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 25, 'Creating and inserting into #lot_ship_staging';

		SELECT
			  ls.[location_type]
			, ls.[mm_number]
			, ls.[lot_id] AS media_lot_id
			, ls.[description]
			, ls.[design_id]
			, ls.[device]
			, ls.[number_of_die_in_pkg]
			, ls.[probe_program_rev]
			, ls.[major_probe_prog_rev]
			, ls.[burn_tape_revision]
			, ls.[custom_testing_reqd]
			, ls.[fab_excr_id]
			, ls.[lot_id]
			, ls.[product_grade]
			, ls.[prb_conv_id]
			, ls.[reticle_wave_id]
			, ls.[cell_revision]
			, ls.[cmos_revision]
			, ls.[fab_conv_id]
			, ls.[shipping_label_lot]
		INTO #lot_ship_staging
		-- FROM [CallistoCommon].[stage].[lot_ship] ls WITH (NOLOCK)
		FROM [TREADSTONEPRD].treadstone.[dbo].[lot_ship] AS ls WITH (NOLOCK)
		INNER JOIN [qan].[OdmWipSnapshots] AS owip WITH (NOLOCK)
			ON owip.media_lot_id = ls.lot_id
		WHERE owip.[Version] = @WipVersion
			AND ls.location_type = 'TST';

		SET @MessageText = 'Number of records inserted into #lot_ship_staging (for join on lot_id): ' + CAST(@@ROWCOUNT AS VARCHAR(20));
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		INSERT INTO #lot_ship_staging
		SELECT
			  ls.[location_type]
			, ls.[mm_number]
			, ls.[shipping_label_lot] AS media_lot_id
			, ls.[description]
			, ls.[design_id]
			, ls.[device]
			, ls.[number_of_die_in_pkg]
			, ls.[probe_program_rev]
			, ls.[major_probe_prog_rev]
			, ls.[burn_tape_revision]
			, ls.[custom_testing_reqd]
			, ls.[fab_excr_id]
			, ls.[lot_id]
			, ls.[product_grade]
			, ls.[prb_conv_id]
			, ls.[reticle_wave_id]
			, ls.[cell_revision]
			, ls.[cmos_revision]
			, ls.[fab_conv_id]
			, ls.[shipping_label_lot]
		--FROM [CallistoCommon].[stage].[lot_ship] ls WITH (NOLOCK)
		FROM [TREADSTONEPRD].treadstone.[dbo].[lot_ship] AS ls WITH (NOLOCK)
		INNER JOIN [qan].[OdmWipSnapshots] AS owip WITH (NOLOCK)
			ON owip.media_lot_id = ls.shipping_label_lot
		WHERE owip.[Version] = @WipVersion
		AND ls.location_type = 'TST';

		SET @MessageText = 'Number of records inserted into #lot_ship_staging (for join on shipping_label_lot): ' + CAST(@@ROWCOUNT AS VARCHAR(20));
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 50, 'Creating and inserting into #lot_ship';

		CREATE TABLE #lot_ship
		(
			  [location_type]         VARCHAR(255)     NULL
			, [mm_number]             VARCHAR(50)      NULL
			, [media_lot_id]          VARCHAR(50)      NULL
			, [description]           VARCHAR(50)      NULL
			, [design_id]             VARCHAR(255)     NULL
			, [device]                VARCHAR(50)      NULL
			, [number_of_die_in_pkg]  INT              NULL
			, [probe_program_rev]     VARCHAR(255)     NULL
			, [major_probe_prog_rev]  VARCHAR(255)     NULL
			, [burn_tape_revision]    VARCHAR(255)     NULL
			, [custom_testing_reqd]   VARCHAR(50)      NULL
			, [fab_excr_id]           VARCHAR(255)     NULL
			, [lot_id]                VARCHAR(50)  NOT NULL
			, [product_grade]         VARCHAR(50)      NULL
			, [prb_conv_id]           VARCHAR(255)     NULL
			, [reticle_wave_id]       VARCHAR(50)      NULL
			, [cell_revision]         VARCHAR(50)      NULL
			, [cmos_revision]         VARCHAR(50)      NULL
			, [fab_conv_id]           VARCHAR(50)      NULL
			, [shipping_label_lot]    VARCHAR(50)      NULL
		);

		INSERT INTO #lot_ship
		SELECT
			  [location_type]
			, [mm_number]
			, [media_lot_id]
			, [description]
			, [design_id]
			, [device]
			, [number_of_die_in_pkg]
			, [probe_program_rev]
			, [major_probe_prog_rev]
			, [burn_tape_revision]
			, [custom_testing_reqd]
			, [fab_excr_id]
			, [lot_id]
			, [product_grade]
			, [prb_conv_id]
			, [reticle_wave_id]
			, [cell_revision]
			, [cmos_revision]
			, [fab_conv_id]
			, [shipping_label_lot]
		FROM #lot_ship_staging
		EXCEPT
		SELECT
			  [location_type]
			, [mm_number]
			, [media_lot_id]
			, [description]
			, [design_id]
			, [device]
			, [number_of_die_in_pkg]
			, [probe_program_rev]
			, [major_probe_prog_rev]
			, [burn_tape_revision]
			, [custom_testing_reqd]
			, [fab_excr_id]
			, [lot_id]
			, [product_grade]
			, [prb_conv_id]
			, [reticle_wave_id]
			, [cell_revision]
			, [cmos_revision]
			, [fab_conv_id]
			, [shipping_label_lot]
		FROM [qan].[OdmLotShipSnapshots] WITH (NOLOCK)
		WHERE [Version] = @Version;

		SELECT @Count = COUNT(*) FROM #lot_ship;

		SET @MessageText = 'Number of records inserted into #lot_ship: ' + CAST(@Count AS VARCHAR(20));
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		IF (@Count > 0)
		BEGIN
			EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 75, 'Creating a new version and inserting into [qan].[OdmLotShipSnapshots]';

			SET @Version = @Version + 1;

			DELETE lss 
			FROM #lot_ship_staging lss WITH (NOLOCK)
			INNER JOIN  [qan].[OdmQualFilterRemovableMedia] rm WITH (NOLOCK)
				ON lss.[media_lot_id] = rm.[SLot]
				AND lss.[mm_number] = rm.[MMNum]
				AND lss.[design_id] = rm.[DesignId]

			INSERT INTO [qan].[OdmLotShipSnapshots]
			(
				  [Version]
				, [location_type]
				, [mm_number]
				, [media_lot_id]
				, [description]
				, [design_id]
				, [device]
				, [number_of_die_in_pkg]
				, [probe_program_rev]
				, [major_probe_prog_rev]
				, [burn_tape_revision]
				, [custom_testing_reqd]
				, [fab_excr_id]
				, [lot_id]
				, [product_grade]
				, [prb_conv_id]
				, [reticle_wave_id]
				, [cell_revision]
				, [cmos_revision]
				, [fab_conv_id]
				, [shipping_label_lot]
			)
			SELECT DISTINCT 
				  @Version
				, [location_type]
				, [mm_number]
				, [media_lot_id]
				, [description]
				, [design_id]
				, [device]
				, [number_of_die_in_pkg]
				, [probe_program_rev]
				, [major_probe_prog_rev]
				, [burn_tape_revision]
				, [custom_testing_reqd]
				, [fab_excr_id]
				, [lot_id]
				, [product_grade]
				, [prb_conv_id]
				, [reticle_wave_id]
				, [cell_revision]
				, [cmos_revision]
				, [fab_conv_id]
				, [shipping_label_lot]
			FROM  #lot_ship_staging lss WITH (NOLOCK)

			SELECT @CountInserted = COUNT(*) FROM #lot_ship_staging;

			SET @MessageText = 'Version ' + CAST(@Version AS VARCHAR(20)) + ' created in [qan].[OdmLotShipSnapshots] with number of records: ' + CAST(@CountInserted AS VARCHAR(20));
			EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		END;

		EXEC [CallistoCommon].[stage].[UpdateTaskEnd] @TaskId;

	END TRY
	BEGIN CATCH

		IF @TaskId IS NOT NULL
		BEGIN
			BEGIN TRY
				SET @MessageText = CAST(ERROR_MESSAGE() AS NVARCHAR(4000));
				EXEC [CallistoCommon].[stage].[UpdateTaskAbort] @TaskId;
				EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Abort', @MessageText;
			END TRY
			BEGIN CATCH
			END CATCH;
		END;

		THROW;

	END CATCH;

END
