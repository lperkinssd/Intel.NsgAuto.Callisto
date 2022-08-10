-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-21 14:22:14.240
-- Description  : Generates and caches MM recipes from the transformed speed data.
--                This task should be executed after TaskSpeedDataTransform as it
--                depends on tables constructed by that task.
-- Example      : EXEC [stage].[TaskSpeedMMRecipeData];
-- =================================================================================
CREATE PROCEDURE [stage].[TaskSpeedMMRecipeData]
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

		EXEC [stage].[CreateTaskByName] @TaskId OUTPUT, 'Speed MM Recipe Data';

		-- Step 1: Create *_New tables
		-- SpeedMMRecipeItems
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 32;
		SET @Progress = @ProgressSubtaskInitial;
		SET @TableId = @TableId + 1;
		SET @ViewName = 'VSpeedMMRecipeItems';
		SET @ViewNameWithSchema = '[' + @Schema + '].[' + @ViewName + ']';
		SET @TableName = 'SpeedMMRecipeItems';
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
		SET @Sql = 'CREATE INDEX IX_RootItemId ON ' + @TableNameWithSchema + ' ([RootItemId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ItemCategory ON ' + @TableNameWithSchema + ' ([ItemCategory])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ItemId ON ' + @TableNameWithSchema + ' ([ItemId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_AssociationType ON ' + @TableNameWithSchema + ' ([AssociationType])';
		EXEC(@Sql);
		SET @MessageText = 'Created indexes on ' + @TableNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		INSERT INTO @Tables VALUES (@TableId, @TableNameNew, @TableName, @TableNamePrevious);

		-- SpeedMMRecipeItemsGbCategory
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 32;
		SET @Progress = @ProgressSubtaskInitial;
		SET @TableId = @TableId + 1;
		SET @ViewName = 'VSpeedMMRecipeItemsGbCategory';
		SET @ViewNameWithSchema = '[' + @Schema + '].[' + @ViewName + ']';
		SET @TableName = 'SpeedMMRecipeItemsGbCategory';
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
		SET @Sql = 'CREATE INDEX IX_RootItemId ON ' + @TableNameWithSchema + ' ([RootItemId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ItemCategory ON ' + @TableNameWithSchema + ' ([ItemCategory])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_MaxItemId ON ' + @TableNameWithSchema + ' ([MaxItemId])';
		EXEC(@Sql);
		SET @MessageText = 'Created indexes on ' + @TableNameWithSchema;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		INSERT INTO @Tables VALUES (@TableId, @TableNameNew, @TableName, @TableNamePrevious);

		-- SpeedMMRecipes
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 32;
		SET @Progress = @ProgressSubtaskInitial;
		SET @TableId = @TableId + 1;
		SET @ViewName = 'VSpeedMMRecipes';
		SET @ViewNameWithSchema = '[' + @Schema + '].[' + @ViewName + ']';
		SET @TableName = 'SpeedMMRecipes';
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
		SET @Sql = 'ALTER TABLE ' + @TableNameWithSchema + ' ALTER COLUMN [RootItemId] NVARCHAR(21) NOT NULL';
		EXEC(@Sql);
		SET @Sql = 'ALTER TABLE ' + @TableNameWithSchema + ' ADD PRIMARY KEY ([RootItemId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_PCode ON ' + @TableNameWithSchema + ' ([PCode])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_SCode ON ' + @TableNameWithSchema + ' ([SCode])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ProductFamily ON ' + @TableNameWithSchema + ' ([ProductFamily])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ProductionProductCode ON ' + @TableNameWithSchema + ' ([ProductionProductCode])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ModelString ON ' + @TableNameWithSchema + ' ([ModelString])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_FormFactorName ON ' + @TableNameWithSchema + ' ([FormFactorName])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_CustomerName ON ' + @TableNameWithSchema + ' ([CustomerName])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_SCodeProductCode ON ' + @TableNameWithSchema + ' ([SCodeProductCode])';
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
