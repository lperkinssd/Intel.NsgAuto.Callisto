-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-06-16 14:21:37.700
-- Description  : Pulls the [qan].[PRFDCR] table from the treadstone database
-- Example      : EXEC [stage].[TaskTreadstonePullPrf];
-- ============================================================================
CREATE PROCEDURE [stage].[TaskTreadstonePullPrf]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText NVARCHAR(4000);
	DECLARE @TaskId BIGINT;

	BEGIN TRY

		EXEC [stage].[CreateTaskByName] @TaskId OUTPUT, 'Treadstone Pull PRF';

		DECLARE @Schema VARCHAR(20) = 'stage';
		DECLARE @Sql NVARCHAR(MAX);
		DECLARE @TableCurrent VARCHAR(100);
		DECLARE @TableName VARCHAR(50) = 'PRFDCR';
		DECLARE @TableNameNew VARCHAR(50) = @TableName + '_New';
		DECLARE @TableNamePrevious VARCHAR(50) = @TableName + '_Previous';
		DECLARE @TableSource VARCHAR(200) = '[TREADSTONEPRD].[treadstone].[qan].[PRFDCR]';

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
		SET @Sql = 'CREATE INDEX [IX_Prf_Id] ON ' + @TableCurrent + ' ([Prf_Id])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_Odm_desc] ON ' + @TableCurrent + ' ([Odm_desc])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_SSD_family_name] ON ' + @TableCurrent + ' ([SSD_family_name])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_MM_number] ON ' + @TableCurrent + ' ([MM_number])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_Product_Code] ON ' + @TableCurrent + ' ([Product_Code])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_Latest] ON ' + @TableCurrent + ' ([Latest])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX [IX_FileType] ON ' + @TableCurrent + ' ([FileType])';
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
