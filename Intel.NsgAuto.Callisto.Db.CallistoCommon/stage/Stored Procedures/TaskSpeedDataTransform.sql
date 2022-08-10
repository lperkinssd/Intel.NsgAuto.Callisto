-- ========================================================
-- Author       : bricschx
-- Create date  : 2020-10-21 14:22:14.240
-- Description  : Transforms and caches speed data
-- Example      : EXEC [stage].[TaskSpeedDataTransform];
-- ========================================================
CREATE PROCEDURE [stage].[TaskSpeedDataTransform]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MaxTableId INT;
	DECLARE @MessageText NVARCHAR(4000);
	DECLARE @Progress TINYINT = 0;
	DECLARE @ProgressSubtaskInitial TINYINT = 0;
	DECLARE @ProgressSubtaskRange TINYINT = 0;
	DECLARE @Schema VARCHAR(20) = 'stage';
	DECLARE @Sql NVARCHAR(MAX);
	DECLARE @TableId INT = 0;
	DECLARE @TableName VARCHAR(200);
	DECLARE @TableNameNew VARCHAR(200);
	DECLARE @TableNameWithSchema VARCHAR(200);
	DECLARE @TableNamePrevious VARCHAR(200);
	DECLARE @Tables TABLE ([Id] INT UNIQUE, [TableNameNew] VARCHAR(200) UNIQUE, [TableName] VARCHAR(200) UNIQUE, [TableNamePrevious] VARCHAR(200) UNIQUE);
	DECLARE @TaskId BIGINT;
	DECLARE @ViewName VARCHAR(200);
	DECLARE @ViewNameWithSchema VARCHAR(200);

	BEGIN TRY

		EXEC [stage].[CreateTaskByName] @TaskId OUTPUT, 'Speed Data Transform';

		-- Step 1: Create *_New tables
		-- SpeedDesignItems
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 24;
		SET @Progress = @ProgressSubtaskInitial;
		SET @TableId = @TableId + 1;
		SET @ViewName = 'VSpeedDesignItems';
		SET @ViewNameWithSchema = '[' + @Schema + '].[' + @ViewName + ']';
		SET @TableName = 'SpeedDesignItems';
		SET @TableNameNew = @TableName + '_New';
		SET @TableNamePrevious = @TableName + '_Previous';
		SET @TableNameWithSchema = '[' + @Schema + '].[' + @TableNameNew + ']';
		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNameNew)
		BEGIN
			SET @Sql = 'DROP TABLE ' + @TableNameWithSchema;
			EXEC(@Sql);
			SET @MessageText = 'Dropped table ' + @TableNameWithSchema;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		END;
		SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * 1 / 5);
		SET @MessageText = 'Creating ' + @TableNameWithSchema + ' table from view ' + @ViewNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
		SET @Sql = 'SELECT * INTO ' + @TableNameWithSchema + ' FROM ' + @ViewNameWithSchema;
		EXEC(@Sql);
		SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * 4 / 5);
		SET @MessageText = 'Created ' + @TableNameWithSchema + ' table from view ' + @ViewNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		SET @MessageText = 'Creating indexes on ' + @TableNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
		SET @Sql = 'ALTER TABLE ' + @TableNameWithSchema + ' ADD PRIMARY KEY ([ItemId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_DesignedFunctionCode ON ' + @TableNameWithSchema + ' ([DesignedFunctionCode])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_DieArchitectureCode ON ' + @TableNameWithSchema + ' ([DieArchitectureCode])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_DieCodeName ON ' + @TableNameWithSchema + ' ([DieCodeName])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_MemoryType1 ON ' + @TableNameWithSchema + ' ([MemoryType1])';
		EXEC(@Sql);
		SET @MessageText = 'Created indexes on ' + @TableNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		INSERT INTO @Tables VALUES (@TableId, @TableNameNew, @TableName, @TableNamePrevious);

		-- SpeedPCodeItems
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 24;
		SET @Progress = @ProgressSubtaskInitial;
		SET @TableId = @TableId + 1;
		SET @ViewName = 'VSpeedPCodeItems';
		SET @ViewNameWithSchema = '[' + @Schema + '].[' + @ViewName + ']';
		SET @TableName = 'SpeedPCodeItems';
		SET @TableNameNew = @TableName + '_New';
		SET @TableNamePrevious = @TableName + '_Previous';
		SET @TableNameWithSchema = '[' + @Schema + '].[' + @TableNameNew + ']';
		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNameNew)
		BEGIN
			SET @Sql = 'DROP TABLE ' + @TableNameWithSchema;
			EXEC(@Sql);
			SET @MessageText = 'Dropped table ' + @TableNameWithSchema;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		END;
		SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * 1 / 5);
		SET @MessageText = 'Creating ' + @TableNameWithSchema + ' table from view ' + @ViewNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
		SET @Sql = 'SELECT * INTO ' + @TableNameWithSchema + ' FROM ' + @ViewNameWithSchema;
		EXEC(@Sql);
		SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * 4 / 5);
		SET @MessageText = 'Created ' + @TableNameWithSchema + ' table from view ' + @ViewNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		SET @MessageText = 'Creating indexes on ' + @TableNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
		SET @Sql = 'ALTER TABLE ' + @TableNameWithSchema + ' ADD PRIMARY KEY ([ItemId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ExternalProductId ON ' + @TableNameWithSchema + ' ([ExternalProductId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_MarketCodeName ON ' + @TableNameWithSchema + ' ([MarketCodeName])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_DieCodeName ON ' + @TableNameWithSchema + ' ([DieCodeName])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ItemMarketName ON ' + @TableNameWithSchema + ' ([ItemMarketName])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ModelStringName ON ' + @TableNameWithSchema + ' ([ModelStringName])';
		EXEC(@Sql);
		SET @MessageText = 'Created indexes on ' + @TableNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		INSERT INTO @Tables VALUES (@TableId, @TableNameNew, @TableName, @TableNamePrevious);

		-- SpeedSCodeItems
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 24;
		SET @Progress = @ProgressSubtaskInitial;
		SET @TableId = @TableId + 1;
		SET @ViewName = 'VSpeedSCodeItems';
		SET @ViewNameWithSchema = '[' + @Schema + '].[' + @ViewName + ']';
		SET @TableName = 'SpeedSCodeItems';
		SET @TableNameNew = @TableName + '_New';
		SET @TableNamePrevious = @TableName + '_Previous';
		SET @TableNameWithSchema = '[' + @Schema + '].[' + @TableNameNew + ']';
		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNameNew)
		BEGIN
			SET @Sql = 'DROP TABLE ' + @TableNameWithSchema;
			EXEC(@Sql);
			SET @MessageText = 'Dropped table ' + @TableNameWithSchema;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		END;
		SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * 1 / 5);
		SET @MessageText = 'Creating ' + @TableNameWithSchema + ' table from view ' + @ViewNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
		SET @Sql = 'SELECT * INTO ' + @TableNameWithSchema + ' FROM ' + @ViewNameWithSchema;
		EXEC(@Sql);
		SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * 4 / 5);
		SET @MessageText = 'Created ' + @TableNameWithSchema + ' table from view ' + @ViewNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		SET @MessageText = 'Creating indexes on ' + @TableNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
		SET @Sql = 'ALTER TABLE ' + @TableNameWithSchema + ' ADD PRIMARY KEY ([ItemId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ExternalProductId ON ' + @TableNameWithSchema + ' ([ExternalProductId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_MarketCodeName ON ' + @TableNameWithSchema + ' ([MarketCodeName])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_DieCodeName ON ' + @TableNameWithSchema + ' ([DieCodeName])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ItemMarketName ON ' + @TableNameWithSchema + ' ([ItemMarketName])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ModelStringName ON ' + @TableNameWithSchema + ' ([ModelStringName])';
		EXEC(@Sql);
		SET @MessageText = 'Created indexes on ' + @TableNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		INSERT INTO @Tables VALUES (@TableId, @TableNameNew, @TableName, @TableNamePrevious);

		-- SpeedIcFlashItems
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 24;
		SET @Progress = @ProgressSubtaskInitial;
		SET @TableId = @TableId + 1;
		SET @ViewName = 'VSpeedIcFlashItems';
		SET @ViewNameWithSchema = '[' + @Schema + '].[' + @ViewName + ']';
		SET @TableName = 'SpeedIcFlashItems';
		SET @TableNameNew = @TableName + '_New';
		SET @TableNamePrevious = @TableName + '_Previous';
		SET @TableNameWithSchema = '[' + @Schema + '].[' + @TableNameNew + ']';
		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNameNew)
		BEGIN
			SET @Sql = 'DROP TABLE ' + @TableNameWithSchema;
			EXEC(@Sql);
			SET @MessageText = 'Dropped table ' + @TableNameWithSchema;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		END;
		SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * 1 / 5);
		SET @MessageText = 'Creating ' + @TableNameWithSchema + ' table from view ' + @ViewNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
		SET @Sql = 'SELECT * INTO ' + @TableNameWithSchema + ' FROM ' + @ViewNameWithSchema;
		EXEC(@Sql);
		SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * 4 / 5);
		SET @MessageText = 'Created ' + @TableNameWithSchema + ' table from view ' + @ViewNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		SET @MessageText = 'Creating indexes on ' + @TableNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
		SET @Sql = 'ALTER TABLE ' + @TableNameWithSchema + ' ADD PRIMARY KEY ([ItemId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_IntelFlash ON ' + @TableNameWithSchema + ' ([IntelFlash])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_MemoryAssyType ON ' + @TableNameWithSchema + ' ([MemoryAssyType])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_MemoryDeviceName ON ' + @TableNameWithSchema + ' ([MemoryDeviceName])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_MemoryType ON ' + @TableNameWithSchema + ' ([MemoryType])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_SpecCode ON ' + @TableNameWithSchema + ' ([SpecCode])';
		EXEC(@Sql);
		SET @MessageText = 'Created indexes on ' + @TableNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		INSERT INTO @Tables VALUES (@TableId, @TableNameNew, @TableName, @TableNamePrevious);

		-- Step 2: Rename tables
		-- only after we get to this point do we proceed with renaming tables
		-- this is to ensure all steps above have been completed successfully
		-- if anything goes wrong above, this step should not occur and the existing tables will still be in place and consistent (although potentially out of date)
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 4;
		SET @Progress = @ProgressSubtaskInitial;
		SET @MaxTableId = @TableId;
		SET @TableId = 1;
		WHILE @TableId <= @MaxTableId
		BEGIN
			SELECT @TableNameNew = [TableNameNew], @TableName = [TableName], @TableNamePrevious = [TableNamePrevious] FROM @Tables WHERE [Id] = @TableId;

			SET @MessageText = 'Renaming tables: ' + @TableName;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;

			-- Drop *_Previous table if it exists
			SET @TableNameWithSchema = '[' + @Schema + '].[' + @TableNamePrevious + ']';
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNamePrevious)
			BEGIN
				SET @Sql = 'DROP TABLE ' + @TableNameWithSchema;
				EXEC(@Sql);
				SET @MessageText = 'Dropped table ' + @TableNameWithSchema;
				EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			END;

			-- Rename * table to *_Previous
			SET @TableNameWithSchema = '[' + @Schema + '].[' + @TableName + ']';
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableName)
			BEGIN
				EXEC sp_rename @TableNameWithSchema, @TableNamePrevious;
				SET @MessageText = 'Renamed table ' + @TableName + ' to ' + @TableNamePrevious;
				EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			END;

			-- Rename *_New table to *
			SET @TableNameWithSchema = '[' + @Schema + '].[' + @TableNameNew + ']';
			EXEC sp_rename @TableNameWithSchema, @TableName;
			SET @MessageText = 'Renamed table ' + @TableNameNew + ' to ' + @TableName;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

			SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * @TableId / @MaxTableId);

			SET @TableId = @TableId + 1;
		END;

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
