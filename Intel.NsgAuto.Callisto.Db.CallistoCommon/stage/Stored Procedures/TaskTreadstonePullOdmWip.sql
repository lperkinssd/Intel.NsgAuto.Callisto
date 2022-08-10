-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-16 12:48:29.137
-- Description  : Pulls the vw_callisto_odm_wip_data view from the treadstone database
-- Example      : EXEC [stage].[TaskTreadstonePullOdmWip];
-- ======================================================================================
CREATE PROCEDURE [stage].[TaskTreadstonePullOdmWip]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText NVARCHAR(4000);
	DECLARE @TaskId BIGINT;

	BEGIN TRY

		EXEC [stage].[CreateTaskByName] @TaskId OUTPUT, 'Treadstone Pull ODM WIP';

		DECLARE @Schema VARCHAR(20) = 'stage';
		DECLARE @Sql NVARCHAR(MAX);
		DECLARE @TableCurrent VARCHAR(100);
		DECLARE @TableName VARCHAR(50) = 'odm_wip_data';
		DECLARE @TableNameNew VARCHAR(50) = @TableName + '_New';
		DECLARE @TableNamePrevious VARCHAR(50) = @TableName + '_Previous';
		DECLARE @TableSource VARCHAR(200) = '[TREADSTONEPRD].[treadstone].[odm].[vw_callisto_odm_wip_data]';

		-- drop the *_New table if it exists; normally, if the previous execution completed successfully, it should not exist
		SET @TableCurrent = '[' + @Schema + '].[' + @TableNameNew + ']';
		SET @MessageText = 'Determining if table exists: ' + ISNULL(@TableCurrent, '');
		EXEC [stage].[UpdateTaskProgress] @TaskId, 0, @MessageText;
		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WITH (NOLOCK) WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNameNew)
		BEGIN
			EXEC('DROP TABLE ' + @TableCurrent);
			SET @MessageText = 'Dropped table ' + @TableCurrent;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		END

		-- create and insert data into the *_New table
		SET @MessageText = 'Creating table ' + @TableCurrent + ' from table ' + @TableSource;
		EXEC [stage].[UpdateTaskProgress] @TaskId, 5, @MessageText;
		SET @Sql = 'SELECT * INTO ' + @TableCurrent + ' FROM ' + @TableSource + ' WITH (NOLOCK)';
		EXEC(@Sql);
		SET @MessageText = 'Created table ' + @TableCurrent + ' table from table ' + @TableSource;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		SET @MessageText = 'Creating indexes on ' + @TableCurrent;
		EXEC [stage].[UpdateTaskProgress] @TaskId, 75, @MessageText;
		SET @Sql = 'CREATE INDEX [IX_media_lot_id] ON ' + @TableCurrent + ' ([media_lot_id])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_subcon_name] ON ' + @TableCurrent + ' ([subcon_name])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_intel_part_number] ON ' + @TableCurrent + ' ([intel_part_number])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_location_type] ON ' + @TableCurrent + ' ([location_type])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_inventory_location] ON ' + @TableCurrent + ' ([inventory_location])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_category] ON ' + @TableCurrent + ' ([category])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_mm_number] ON ' + @TableCurrent + ' ([mm_number])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_time_entered] ON ' + @TableCurrent + ' ([time_entered])';
		SET @MessageText = 'Created indexes on ' + @TableCurrent;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		-- drop the *_Previous table if it exists; normally, if this isn't the first execution, it should exist
		SET @TableCurrent = '[' + @Schema + '].[' + @TableNamePrevious + ']';
		SET @MessageText = 'Determining if table exists: ' + ISNULL(@TableCurrent, '');
		EXEC [stage].[UpdateTaskProgress] @TaskId, 90, @MessageText;
		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WITH (NOLOCK) WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNamePrevious)
		BEGIN
			EXEC('DROP TABLE ' + @TableCurrent);
			SET @MessageText = 'Dropped table ' + @TableCurrent;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		END

		-- only after we get to this point successfully do we proceed with renaming the tables
		SET @MessageText = 'Renaming tables';
		EXEC [stage].[UpdateTaskProgress] @TaskId, 95, @MessageText;

		-- rename the existing table to *_Previous if it exists
		SET @TableCurrent = '[' + @Schema + '].[' + @TableName + ']';
		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WITH (NOLOCK) WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableName)
		BEGIN
			EXEC sp_rename @TableCurrent, @TableNamePrevious;
			SET @MessageText = 'Renamed table ' + @TableName + ' to ' + @TableNamePrevious;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		END

		-- rename the *_New table to existing
		SET @TableCurrent = '[' + @Schema + '].[' + @TableNameNew + ']';
		EXEC sp_rename @TableCurrent, @TableName;
		SET @MessageText = 'Renamed table ' + @TableNameNew + ' to ' + @TableName;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [stage].[UpdateTaskEnd] @TaskId;

	END TRY
	BEGIN CATCH

		IF @TaskId IS NOT NULL
		BEGIN
			BEGIN TRY
				SET @MessageText = CAST(ERROR_MESSAGE() AS NVARCHAR(4000));
				EXEC [stage].[UpdateTaskAbort] @TaskId;
				EXEC [stage].[CreateTaskMessage] @TaskId, 'Abort', @MessageText;
			END TRY
			BEGIN CATCH
			END CATCH;
		END;

		THROW;

	END CATCH;

END
