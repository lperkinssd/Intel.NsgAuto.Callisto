


-- ================================================================================================
-- Author      : jkurian
-- Create date : 2021-08-12 15:20:24.587
-- Description : Create records in [npsg].[OdmWipBohSnapshots] from the historical data in
--               [TREADSTONENPSGPRD].[treadstone].[odm].[vw_odm_wip_data_history]
-- Notes       : Copied and tweaked from [npsg].[TaskCreateOdmQualFilterWipSnapshot]
-- Example     : EXEC [npsg].[TaskCreateOdmQualFilterHistoricalWipBohSnapshot];
-- ================================================================================================
CREATE PROCEDURE [npsg].[TaskCreateOdmQualFilterHistoricalWipBohSnapshot]
(
	  @CountInserted INT = NULL OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText  NVARCHAR(4000);
	DECLARE @TaskId       BIGINT;

	SET @CountInserted = 0;

	BEGIN TRY

		EXEC [CallistoCommon].[stage].[CreateTaskByName] @TaskId OUTPUT, 'Create ODM QF NPSG Historical WIP BOH Snapshot';
		DECLARE @Count         INT;
		DECLARE @LatestMatVersion INT = (SELECT MAX([MatVersion]) FROM [npsg].[MAT] WITH (NOLOCK));

		-- If MAT is not present, there is no point in loading wip history. So raise an error and exit with out loading history

		IF OBJECT_ID('tempdb..#owip_history_mat') IS NOT NULL          DROP TABLE #owip_history_mat;
		IF OBJECT_ID('tempdb..#owip_history_staging') IS NOT NULL      DROP TABLE #owip_history_staging;
		IF OBJECT_ID('tempdb..#OldestWipForSLots') IS NOT NULL			DROP TABLE #OldestWipForSLots;
		IF OBJECT_ID('tempdb..#odm_history_wip_diff') IS NOT NULL		DROP TABLE #odm_history_wip_diff;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 30, 'Creating temp table #owip_history_mat to get unique IPNs from MAT';

		SELECT DISTINCT 
			m.Media_IPN 
		INTO #owip_history_mat
		FROM [npsg].[MAT] m WITH (NOLOCK)
		WHERE m.MatVersion = @LatestMatVersion;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 30, 'Creating temp table #OldestWipForSLots to hold oldest records';
		CREATE TABLE #OldestWipForSLots
		(
			[media_lot_id] [varchar](255) NOT NULL,
			[subcon_name] [varchar](255) NOT NULL,
			[intel_part_number] [varchar](255) NOT NULL,
			[time_entered] [datetime2](7) NULL
		);
		INSERT INTO #OldestWipForSLots
		(
			  ows.[media_lot_id]
			, ows.[subcon_name]
			, ows.[intel_part_number]
			, ows.[time_entered]
		)
		SELECT
			  UPPER(RTRIM(LTRIM((ows.media_lot_id)))) AS media_lot_id
			, UPPER(RTRIM(LTRIM((ows.subcon_name)))) AS subcon_name
			, ows.[intel_part_number]
			, MIN(ows.time_entered) as [time_entered] -- Find oldest record
		FROM [TREADSTONENPSGPRD].[treadstone].[odm].[vw_odm_wip_data_history] ows WITH (NOLOCK) -- from history
		INNER JOIN #owip_history_mat m WITH (NOLOCK)
			ON ows.intel_part_number = m.Media_IPN
		WHERE location_type = 'ODM BOH'
		GROUP BY ows.media_lot_id, ows.subcon_name, ows.[intel_part_number];
			
		--EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 30, 'Creating temp table #wip_history_staging to hold historical wip';
		CREATE TABLE #owip_history_staging
		(
			[media_lot_id] [varchar](255) NOT NULL,
			[subcon_name] [varchar](255) NOT NULL,
			[intel_part_number] [varchar](255) NULL
		);
		INSERT INTO #owip_history_staging
		(
			  [media_lot_id]
			, [subcon_name]
			, [intel_part_number]
		)
		SELECT DISTINCT
			  ows.media_lot_id
			, UPPER(RTRIM(LTRIM((ows.subcon_name)))) AS subcon_name
			, ows.intel_part_number
		FROM #OldestWipForSLots ows

		SET @MessageText = 'Created temp table #owip_history_staging';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 70, 'Creating temp table #odm_history_wip_diff';
		CREATE TABLE #odm_history_wip_diff
		(
			[media_lot_id] [varchar](255) NOT NULL,
			[subcon_name] [varchar](255) NOT NULL,
			[intel_part_number] [varchar](255) NULL
		);
		SET @MessageText = 'Created temp table #odm_history_wip_diff';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 80, 'Inserting records into #odm_history_wip_diff';
		INSERT INTO #odm_history_wip_diff
			SELECT
				  [media_lot_id]
				, [subcon_name]
				, [intel_part_number]
			FROM #owip_history_staging
			EXCEPT
			SELECT
				  [media_lot_id]
				, [subcon_name]
				, [intel_part_number]
			FROM [npsg].[OdmWipBohSnapshots] WITH (NOLOCK)

		-- Find out if the data got changed after the last version was created. 
		SELECT @Count = COUNT(*) FROM #odm_history_wip_diff;
		SET @MessageText = 'Number of records inserted into #odm_history_wip_diff = ' + CAST(@Count AS VARCHAR(20));
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		-- There is new data
		IF (@Count > 0)
		BEGIN

			EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 90, 'Creating a new version and inserting records into [npsg].[OdmWipBohSnapshots]';

			INSERT INTO [npsg].[OdmWipBohSnapshots] (
				[media_lot_id]
			   ,[subcon_name]
			   ,[intel_part_number]
			   )
			SELECT DISTINCT
				  ohw.[media_lot_id]
				, UPPER(ohw.[subcon_name]) AS subcon_name
				, ohw.[intel_part_number]
			FROM #odm_history_wip_diff ohw WITH (NOLOCK)

			SET @MessageText = 'Created in [npsg].[OdmWipBohSnapshots] with number of records: ' + CAST(@Count AS VARCHAR(20));
			EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		END;

		EXEC [CallistoCommon].[stage].[UpdateTaskEnd] @TaskId;

	END TRY
	BEGIN CATCH
		
		IF @TaskId IS NOT NULL
		BEGIN
			BEGIN TRY
				SET @MessageText = CAST(ERROR_MESSAGE() AS NVARCHAR(4000)) + ' occurred at line ' + CAST(ERROR_LINE() AS NVARCHAR(50)) ;
				EXEC [CallistoCommon].[stage].[UpdateTaskAbort] @TaskId;
				EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Abort', @MessageText;
			END TRY
			BEGIN CATCH
			END CATCH;
		END;

		THROW;

	END CATCH;

END