-- =======================================================================
-- Author       : bricschx
-- Create date  : 2020-11-11 09:47:59.133
-- Description  : Pulls the lot_ship table from the treadstone database
-- Example      : EXEC [stage].[TaskTreadstonePullLotShip];
-- =======================================================================
CREATE PROCEDURE [stage].[TaskTreadstonePullLotShip]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText NVARCHAR(4000);
	DECLARE @TaskId BIGINT;

	BEGIN TRY

		EXEC [stage].[CreateTaskByName] @TaskId OUTPUT, 'Treadstone Pull Lot Ship';

		DECLARE @Schema VARCHAR(20) = 'stage';
		DECLARE @Sql NVARCHAR(MAX);
		DECLARE @TableCurrent VARCHAR(100);
		DECLARE @TableName VARCHAR(50) = 'lot_ship';
		DECLARE @TableNameNew VARCHAR(50) = @TableName + '_New';
		DECLARE @TableNamePrevious VARCHAR(50) = @TableName + '_Previous';
		DECLARE @TableSource VARCHAR(200) = '[TREADSTONEPRD].[treadstone].[dbo].[lot_ship]';

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
		SET @Sql = 'ALTER TABLE ' + @TableCurrent + ' ADD PRIMARY KEY ([id])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_location_type] ON ' + @TableCurrent + ' ([location_type])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_mm_number] ON ' + @TableCurrent + ' ([mm_number])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_intel_upi] ON ' + @TableCurrent + ' ([intel_upi])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_design_id] ON ' + @TableCurrent + ' ([design_id])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_major_probe_prog_rev] ON ' + @TableCurrent + ' ([major_probe_prog_rev])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_fabrication_facility] ON ' + @TableCurrent + ' ([fabrication_facility])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_app_restriction] ON ' + @TableCurrent + ' ([app_restriction])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_custom_testing_reqd] ON ' + @TableCurrent + ' ([custom_testing_reqd])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_fab_excr_id] ON ' + @TableCurrent + ' ([fab_excr_id])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_lot_id] ON ' + @TableCurrent + ' ([lot_id])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_product_grade] ON ' + @TableCurrent + ' ([product_grade])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_prb_conv_id] ON ' + @TableCurrent + ' ([prb_conv_id])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_reticle_wave_id] ON ' + @TableCurrent + ' ([reticle_wave_id])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_cell_revision] ON ' + @TableCurrent + ' ([cell_revision])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_cmos_revision] ON ' + @TableCurrent + ' ([cmos_revision])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_country_of_assembly] ON ' + @TableCurrent + ' ([country_of_assembly])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_shipping_label_lot] ON ' + @TableCurrent + ' ([shipping_label_lot])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_fab_conv_id] ON ' + @TableCurrent + ' ([fab_conv_id])';
		EXEC(@Sql);
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
