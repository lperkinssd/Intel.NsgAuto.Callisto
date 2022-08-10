


-- ================================================================================================
-- Author      : jkurian
-- Create date : 2021-06-11 16:09:21.057
-- Description : Create records in [qan].[OdmWipSnapshots] from the latest data in
--               [TREADSTONEPRD].[treadstone].[odm].[vw_callisto_odm_wip_data]
-- Notes       : This must be called before [qan].[TaskCreateOdmQualFilterLotShipSnapshot]
--               due to a dependency. Copied and tweaked from [qan].[CreateOdmWipSnapshotDaily]
-- Example     : EXEC [qan].[TaskCreateOdmQualFilterWipSnapshot];
-- ================================================================================================
CREATE PROCEDURE [qan].[TaskCreateOdmQualFilterWipSnapshot]
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

		EXEC [CallistoCommon].[stage].[CreateTaskByName] @TaskId OUTPUT, 'Create ODM QF WIP Snapshot';
		DECLARE @Count         INT;
		DECLARE @Version       INT = (SELECT ISNULL(MAX([Version]), 0) FROM [qan].[OdmWipSnapshots] WITH (NOLOCK));

		IF OBJECT_ID('tempdb..#owip_staging') IS NOT NULL            DROP TABLE #owip_staging;
		IF OBJECT_ID('tempdb..#LatestWipForSLots') IS NOT NULL       DROP TABLE #LatestWipForSLots;
		IF OBJECT_ID('tempdb..#odm_wip_diff') IS NOT NULL            DROP TABLE #odm_wip_diff;
		
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 30, 'Creating temp table #owip_staging';

		CREATE TABLE #LatestWipForSLots
		(
			[media_lot_id] [varchar](255) NOT NULL,
			[subcon_name] [varchar](255) NOT NULL,
			[time_entered] [datetime2](7) NULL
		);
		INSERT INTO #LatestWipForSLots
		(
			  [media_lot_id]
			, [subcon_name]
			, [time_entered]
		)
		SELECT 
			   UPPER(RTRIM(LTRIM((ows.media_lot_id)))) AS media_lot_id
			, UPPER(RTRIM(LTRIM((ows.subcon_name)))) AS subcon_name
			, max(ows.time_entered) as [time_entered]
		FROM [TREADSTONEPRD].[treadstone].[odm].[vw_callisto_odm_wip_data] ows WITH (NOLOCK)
		GROUP BY ows.media_lot_id, ows.subcon_name;
			
		CREATE TABLE #owip_staging
		(
			[media_lot_id] [varchar](255) NOT NULL,
			[subcon_name] [varchar](255) NOT NULL,
			[intel_part_number] [varchar](255) NULL,
			[location_type] [varchar](255) NULL,
			[inventory_location] [varchar](255) NULL,
			[category] [varchar](255) NULL,
			[mm_number] [varchar](255) NULL,
			[time_entered] [datetime2](7) NULL
		);

		INSERT INTO #owip_staging
		(
			  [media_lot_id]
			, [subcon_name]
			, [intel_part_number]
			, [location_type]
			, [inventory_location]
			, [category]
			, [mm_number]
			, [time_entered]
		)
		SELECT 
			  ows.media_lot_id
			, UPPER(RTRIM(LTRIM((ows.subcon_name)))) AS subcon_name
			, ows.intel_part_number
			, ows.location_type
			, ows.inventory_location
			, ows.category
			, ows.mm_number
			, ows.time_entered
		FROM [TREADSTONEPRD].[treadstone].[odm].[vw_callisto_odm_wip_data] ows WITH (NOLOCK)
		INNER JOIN #LatestWipForSLots lwsl  WITH (NOLOCK)
			ON ows.media_lot_id = lwsl.media_lot_id
			AND ows.subcon_name = lwsl.subcon_name
			AND ows.time_entered = lwsl.time_entered;

		SET @MessageText = 'Created temp table #owip_staging';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 70, 'Creating temp table #odm_wip_diff';
		CREATE TABLE #odm_wip_diff
		(
			[media_lot_id] [varchar](255) NOT NULL,
			[subcon_name] [varchar](255) NOT NULL,
			[intel_part_number] [varchar](255) NULL,
			[location_type] [varchar](255) NULL,
			[inventory_location] [varchar](255) NULL,
			[category] [varchar](255) NULL,
			[mm_number] [varchar](255) NULL,
			[time_entered] [datetime2](7) NULL
		);
		SET @MessageText = 'Created temp table #odm_wip_diff';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 80, 'Inserting records into #odm_wip_diff';
		INSERT INTO #odm_wip_diff
			SELECT
				  [media_lot_id]
				, [subcon_name]
				, [intel_part_number]
				, [location_type]
				, [inventory_location]
				, [category]
				, [mm_number]
				, [time_entered]
			FROM #owip_staging
			EXCEPT
			SELECT
				  [media_lot_id]
				, [subcon_name]
				, [intel_part_number]
				, [location_type]
				, [inventory_location]
				, [category]
				, [mm_number]
				, [time_entered]
			FROM [qan].[OdmWipSnapshots] WITH (NOLOCK)
			WHERE [Version] = @Version;

		SELECT @Count = COUNT(*) FROM #odm_wip_diff;
		SET @MessageText = 'Number of records inserted into #odm_wip_diff = ' + CAST(@Count AS VARCHAR(20));
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		-- There is new data
		IF (@Count > 0)
		BEGIN

			EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 90, 'Creating a new version and inserting records into [qan].[OdmWipSnapshots]';
			SET @Version = @Version + 1;

			DELETE ows 
			FROM #owip_staging ows WITH (NOLOCK)
			INNER JOIN  [qan].[OdmQualFilterRemovableMedia] rm WITH (NOLOCK)
				ON rm.[SLot] = ows.[media_lot_id]
				AND rm.[MediaIPN] = ows.[intel_part_number]
				AND rm.[MMNum] = ows.[mm_number]
			INNER JOIN  [ref].[Odms] odm WITH (NOLOCK)
				ON rm.[OdmId] = odm.[Id]
				AND odm.[Name] = ows.[subcon_name]

			INSERT INTO [qan].[OdmWipSnapshots]
			SELECT DISTINCT
				  @Version
				, [media_lot_id]
				, UPPER([subcon_name]) AS subcon_name
				, [intel_part_number]
				, [location_type]
				, [inventory_location]
				, [category]
				, [mm_number]
				, [time_entered]
			FROM #owip_staging ows WITH (NOLOCK)

			SELECT @CountInserted = COUNT(*) FROM #owip_staging;
			SET @MessageText = 'Version ' + CAST(@Version AS VARCHAR(20)) + ' created in [qan].[OdmWipSnapshots] with number of records: ' + CAST(@CountInserted AS VARCHAR(20));
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
