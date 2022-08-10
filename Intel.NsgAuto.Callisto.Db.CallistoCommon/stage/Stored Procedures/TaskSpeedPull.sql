-- ===================================================
-- Author		: bricschx
-- Create date	: 2020-09-03 16:00:42.060
-- Description	: Pulls data from the Speed system
-- Example      : EXEC [stage].[TaskSpeedPull];
-- ===================================================
CREATE PROCEDURE [stage].[TaskSpeedPull]
(
	@LinkedServer VARCHAR(15) = 'DENODOODBCPRD',
	@LimitTreeItemsCount INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @BatchIndex INT;
	DECLARE @BatchItemIds [stage].[IStrings];
	DECLARE @BatchSize INT;
	DECLARE @Columns VARCHAR(MAX);
	DECLARE @ConsolidatedItemIds [stage].[IStrings];
	DECLARE @Count INT;
	DECLARE @CountBatches INT;
	DECLARE @CountBatchIds INT;
	DECLARE @CountItems INT;
	DECLARE @DesignItemIds [stage].[IStrings];
	DECLARE @IncludeItemDetails BIT = 1;
	DECLARE @IncludeItemCharacteristics BIT = 1;
	DECLARE @ItemIdIn VARCHAR(MAX);
	DECLARE @ItemIds [stage].[IStrings];
	DECLARE @MaxTableId INT;
	DECLARE @MessageText NVARCHAR(4000);
	DECLARE @PCodes [stage].[IStrings];
	DECLARE @Progress TINYINT = 0;
	DECLARE @ProgressSubtaskInitial TINYINT = 0;
	DECLARE @ProgressSubtaskRange TINYINT = 0;
	DECLARE @Schema VARCHAR(20) = 'stage';
	DECLARE @SpeedViewName VARCHAR(50);
	DECLARE @Sql NVARCHAR(MAX);
	DECLARE @Synonym VARCHAR(200);
	DECLARE @TableId INT = 0;
	DECLARE @TableName VARCHAR(200);
	DECLARE @TableNameBOMNewWithSchema VARCHAR(200);
	DECLARE @TableNameNew VARCHAR(200);
	DECLARE @TableNameCurrentWithSchema VARCHAR(200);
	DECLARE @TableNamePrevious VARCHAR(200);
	DECLARE @Tables TABLE ([Id] INT UNIQUE, [TableNameNew] VARCHAR(200) UNIQUE, [TableName] VARCHAR(200) UNIQUE, [TableNamePrevious] VARCHAR(200) UNIQUE);
	DECLARE @TaskId BIGINT;
	DECLARE @TreeItemIds [stage].[IStrings];

	BEGIN TRY

		EXEC [stage].[CreateTaskByName] @TaskId OUTPUT, 'Speed Pull';

		-- Note: Currently doing all open queries in batches due to API constraints and speed issues
		-- Note: Double escaping of the ' character is required for any strings that will end up in the various open queries

		-- Step 1: Get a distinct list of all p-codes (which will be the root of item trees)
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 1;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @ProgressSubtaskInitial, 'Determining p-codes to pull data for';
		INSERT INTO @PCodes SELECT [PCode] FROM [stage].[PCodes] WITH (NOLOCK) WHERE [IncludeSpeedPull] = 1;
		SET @Count = @@ROWCOUNT;
		SET @MessageText = 'Number of p-codes to pull data for : ' + CAST(@Count AS VARCHAR);
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		INSERT INTO @ItemIds SELECT * FROM @PCodes;

		-- Step 2: Pull the BOM detail for all records where ChildItemId = pcode (determined in step 1)
		-- this step is needed to determine the parent item ids for the pcodes (which are not in the p-code item tree)
		-- BillOfMaterialDetailV2
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 24;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @ProgressSubtaskInitial, 'Preparing to pull BillOfMaterialDetailV2 data';
		SET @TableId = @TableId + 1;
		SET @SpeedViewName = 'BillOfMaterialDetailV2';
		SET @TableName = @SpeedViewName;
		SET @TableNameNew = @TableName + '_New';
		SET @TableNamePrevious = @TableName + '_Previous';
		SET @TableNameCurrentWithSchema = '[' + @Schema + '].[' + @TableNameNew + ']';
		SET @TableNameBOMNewWithSchema = @TableNameCurrentWithSchema;
		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNameNew)
		BEGIN
			SET @Sql = 'DROP TABLE ' + @TableNameCurrentWithSchema;
			EXEC(@Sql);
			SET @MessageText = 'Dropped table ' + @TableNameCurrentWithSchema;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		END;
		SET @BatchSize = 50;
		SET @BatchIndex = 1;
		SELECT @CountItems = COUNT(*) FROM @ItemIds;
		SET @CountBatches = CEILING(@CountItems / @BatchSize);
		IF @CountBatches = 0 SET @CountBatches = 1;
		SET @MessageText = 'Starting batched pulls of size ' + CAST(@BatchSize AS VARCHAR) + ' into ' + @TableNameCurrentWithSchema + ' from speed view ' + @SpeedViewName;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		WHILE (@BatchIndex = 1 OR EXISTS (SELECT * FROM @ItemIds))
		BEGIN
			INSERT INTO @BatchItemIds SELECT TOP (@BatchSize) * FROM @ItemIds;
			SET @CountBatchIds = @@ROWCOUNT;
			SELECT @ItemIdIn = [stage].[ToDelimitedString](@BatchItemIds, ',', ''''''); -- the 2nd parameter might look weird due to escaping rules, but is simply a string containing two single quote characters: ''
			SET @Columns = '"BillOfMaterialId", "ParentItemId", "ChildItemId", "ParentItemRevisionNbr", "ParentBusinessUnitId", "ParentBusinessUnitNm", "BillOfMaterialFindNbr", "BillOfMaterialAssociationTypeCd", "BillOfMaterialAssociationTypeNm", "BillOfMaterialStructureTypeNm", "ChildQty", "NoExplosionInd", "CreateAgentId", "CreateDtm", "ChangeAgentId", "ChangeDtm"';
			IF (@BatchIndex = 1)
			BEGIN
				SET @Sql = 'SELECT GETUTCDATE() AS PullDateTime, * INTO ' + @TableNameCurrentWithSchema + ' FROM OPENQUERY (' + @LinkedServer + ', ''SELECT ' + @Columns + ' FROM "' + @SpeedViewName + '" WHERE "ChildItemId" IN (' + @ItemIdIn + ')'')';
			END;
			ELSE
			BEGIN
				SET @Sql = 'INSERT INTO ' + @TableNameCurrentWithSchema + ' SELECT GETUTCDATE() AS PullDateTime, * FROM OPENQUERY (' + @LinkedServer + ', ''SELECT ' + @Columns + ' FROM "' + @SpeedViewName + '" WHERE "ChildItemId" IN (' + @ItemIdIn + ')'')';
			END;
			EXEC(@Sql);
			SET @Count = @@ROWCOUNT;
			SET @MessageText = @SpeedViewName + ': Pulled batch ' + CAST(@BatchIndex AS VARCHAR) + ' of ' + CAST(@CountBatches AS VARCHAR) + ' containing ' + CAST(@Count AS VARCHAR) + ' record(s)';
			SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * @BatchIndex / @CountBatches);
			EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
			DELETE FROM @ItemIds WHERE [Value] IN (SELECT * FROM @BatchItemIds);
			DELETE FROM @BatchItemIds;
			SET @BatchIndex = @BatchIndex + 1;
		END;
		SET @MessageText = 'Completed batched data pulls into ' + @TableNameCurrentWithSchema + ' from speed view ' + @SpeedViewName;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		SET @Sql = 'CREATE INDEX IX_BillOfMaterialId ON ' + @TableNameCurrentWithSchema + ' ([BillOfMaterialId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ParentItemId ON ' + @TableNameCurrentWithSchema + ' ([ParentItemId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ChildItemId ON ' + @TableNameCurrentWithSchema + ' ([ChildItemId])';
		EXEC(@Sql);
		INSERT INTO @Tables VALUES (@TableId, @TableNameNew, @TableName, @TableNamePrevious);

		-- reset this to contain all p-codes
		DELETE FROM @ItemIds;
		INSERT INTO @ItemIds SELECT * FROM @PCodes;

		-- this code makes the Production Product Code the root of the item trees
		-- for now just treating p-codes as the root of the trees
		--DELETE FROM @ItemIds;
		--SET @Sql = 'SELECT DISTINCT [ParentItemId] FROM ' + @TableNameCurrentWithSchema + ' WITH (NOLOCK) WHERE [ParentItemId] IS NOT NULL';
		--INSERT INTO @ItemIds EXEC sp_executesql @Sql;
		--SET @Count = @@ROWCOUNT;
		--SET @MessageText = 'Number of distinct pcode parent item ids : ' + CAST(@Count AS VARCHAR);
		--EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		-- Step 3: Pull the entire p-code tree, containing parent-child relationships, for each p-code (determined in Step 1)
		-- BillOfMaterialExplosionDetailV2
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 24;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @ProgressSubtaskInitial, 'Preparing to pull BillOfMaterialExplosionDetailV2 data';
		SET @TableId = @TableId + 1;
		SET @SpeedViewName = 'BillOfMaterialExplosionDetailV2';
		SET @TableName = @SpeedViewName;
		SET @TableNameNew = @TableName + '_New';
		SET @TableNamePrevious = @TableName + '_Previous';
		SET @TableNameCurrentWithSchema = '[' + @Schema + '].[' + @TableNameNew + ']';
		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNameNew)
		BEGIN
			SET @Sql = 'DROP TABLE ' + @TableNameCurrentWithSchema;
			EXEC(@Sql);
			SET @MessageText = 'Dropped table ' + @TableNameCurrentWithSchema;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		END;
		SET @BatchSize = 10;
		SET @BatchIndex = 1;
		SELECT @CountItems = COUNT(*) FROM @ItemIds;
		SET @CountBatches = CEILING(@CountItems / @BatchSize);
		IF @CountBatches = 0 SET @CountBatches = 1;
		SET @MessageText = 'Starting batched pulls of size ' + CAST(@BatchSize AS VARCHAR) + ' into ' + @TableNameCurrentWithSchema + ' from speed view ' + @SpeedViewName;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		WHILE (@BatchIndex = 1 OR EXISTS (SELECT * FROM @ItemIds))
		BEGIN
			INSERT INTO @BatchItemIds SELECT TOP (@BatchSize) * FROM @ItemIds;
			SET @CountBatchIds = @@ROWCOUNT;
			SELECT @ItemIdIn = [stage].[ToDelimitedString](@BatchItemIds, ',', '''''');
			SET @Columns = '"@ItemId", "RootItemId", "RootItemRevisionNbr", "BillOfMaterialLevelNbr", "ParentBillOfMaterialRowNbr", "BillOfMaterialRowNbr", "ParentItemId", "ParentItemRevisionNbr", "ChildItemId", "ChildItemRevisionNbr", "ItemDsc", "ReleaseStatusCd", "ReleaseStatusNm", "ItemRevisionCreateDtm", "ChildQuantityRequiredNbr", "UnitOfMeasureCd", "UnitOfWeightCd", "BillOfMaterialFindNbr", "BillOfMaterialTypeCd", "BillOfMaterialAssociationTypeNm", "BillOfMaterialStructureTypeNm", "CommodityCd", "CommodityCodeDsc", "MaterialTypeCd", "ItemTypeCd", "ItemClassDsc", "ItemRevisionProjectCd", "BusinessUnitId", "BusinessUnitNm", "MakeBuyNm", "SortOrderNbr", "NoExplosionInd", "CreateAgentId", "CreateDtm", "ChangeAgentId", "ChangeDtm"';
			IF (@BatchIndex = 1)
			BEGIN
				SET @Sql = 'SELECT GETUTCDATE() AS PullDateTime, * INTO ' + @TableNameCurrentWithSchema + ' FROM OPENQUERY (' + @LinkedServer + ', ''SELECT ' + @Columns + ' FROM "' + @SpeedViewName + '" WHERE "@ItemId" IN (' + @ItemIdIn + ')'')';
			END;
			ELSE
			BEGIN
				SET @Sql = 'INSERT INTO ' + @TableNameCurrentWithSchema + ' SELECT GETUTCDATE() AS PullDateTime, * FROM OPENQUERY (' + @LinkedServer + ', ''SELECT ' + @Columns + ' FROM "' + @SpeedViewName + '" WHERE "@ItemId" IN (' + @ItemIdIn + ')'')';
			END;
			EXEC(@Sql);
			SET @Count = @@ROWCOUNT;
			SET @MessageText = @SpeedViewName + ': Pulled batch ' + CAST(@BatchIndex AS VARCHAR) + ' of ' + CAST(@CountBatches AS VARCHAR) + ' containing ' + CAST(@Count AS VARCHAR) + ' record(s)';
			SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * @BatchIndex / @CountBatches);
			EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
			DELETE FROM @ItemIds WHERE [Value] IN (SELECT * FROM @BatchItemIds);
			DELETE FROM @BatchItemIds;
			SET @BatchIndex = @BatchIndex + 1;
		END;
		SET @MessageText = 'Completed batched data pulls into ' + @TableNameCurrentWithSchema + ' from speed view ' + @SpeedViewName;
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		SET @Sql = 'CREATE INDEX IX_ItemId ON ' + @TableNameCurrentWithSchema + ' ([@ItemId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ParentItemId ON ' + @TableNameCurrentWithSchema + ' ([ParentItemId])';
		EXEC(@Sql);
		SET @Sql = 'CREATE INDEX IX_ChildItemId ON ' + @TableNameCurrentWithSchema + ' ([ChildItemId])';
		EXEC(@Sql);
		INSERT INTO @Tables VALUES (@TableId, @TableNameNew, @TableName, @TableNamePrevious);

		--@TableNameBOMNewWithSchema
		-- Step 4A: Determine all **distinct** items spanning all item trees (determined in Step 1 and 2)
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 1;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @ProgressSubtaskInitial, 'Determining distinct tree items';
		SET @Sql = 'SELECT DISTINCT * FROM (SELECT DISTINCT [ChildItemId] AS [ItemId] FROM ' + @TableNameCurrentWithSchema + ' WITH (NOLOCK) WHERE [ChildItemId] IS NOT NULL UNION SELECT DISTINCT [ParentItemId] AS [ItemId] FROM ' + @TableNameBOMNewWithSchema + ' WITH (NOLOCK) WHERE [ParentItemId] IS NOT NULL) AS T';
		-- limit to important items: AND ([ItemClassDsc] = ''PRODUCT'' OR ([ItemClassDsc] = ''BD'' AND [CommodityCd] IN (''0301'', ''95990375'')) OR [ItemDsc] LIKE ''TA,%'' OR [ItemDsc] LIKE ''SA,%'' OR [ItemDsc] LIKE ''PBA,%'' OR [ItemDsc] LIKE ''AA,%'' OR [ItemDsc] LIKE ''FIRMWARE,%'')
		INSERT INTO @TreeItemIds EXEC sp_executesql @Sql;
		SET @Count = @@ROWCOUNT;
		SET @MessageText = 'Number of distinct tree item ids : ' + CAST(@Count AS VARCHAR);
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		IF (@LimitTreeItemsCount IS NOT NULL AND @LimitTreeItemsCount >= 0)
		BEGIN
			DELETE FROM @ItemIds;
			INSERT INTO @ItemIds SELECT TOP (@LimitTreeItemsCount) * FROM @TreeItemIds;
			DELETE FROM @TreeItemIds;
			INSERT INTO @TreeItemIds SELECT * FROM @ItemIds;
			SET @MessageText = 'Limiting subsequent pulls to the first ' + CAST(@LimitTreeItemsCount AS VARCHAR) + ' tree item(s) only';
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		END;

		-- Step 4B: Determine all design items (exact speed query criteria provided by Mengshu Huang on 2/19/2021)
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 1;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @ProgressSubtaskInitial, 'Determining all distinct design items';
		SET @Sql = 'SELECT * FROM OPENQUERY (' + @LinkedServer + ', ''SELECT DISTINCT "ItemId" FROM "ItemDetailV2" WHERE "BusinessUnitNm" = ''''NAND_NAND'''' AND "ItemClassNm" = ''''UPI_FAB'''' '')';
		INSERT INTO @DesignItemIds EXEC sp_executesql @Sql;
		SET @Count = @@ROWCOUNT;
		SET @MessageText = 'Number of distinct design item ids : ' + CAST(@Count AS VARCHAR);
		EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		INSERT INTO @ConsolidatedItemIds SELECT * FROM @TreeItemIds UNION SELECT * FROM @DesignItemIds;

		-- Step 5: Get additional information about each distinct item (determined in Step 4)

		-- Step 5A: ItemDetailV2
		IF (@IncludeItemDetails = 1)
		BEGIN
			DELETE FROM @ItemIds;
			INSERT INTO @ItemIds SELECT * FROM @ConsolidatedItemIds;

			SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
			SET @ProgressSubtaskRange = 24;
			EXEC [stage].[UpdateTaskProgress] @TaskId, @ProgressSubtaskInitial, 'Preparing to pull ItemDetailV2 data';
			SET @TableId = @TableId + 1;
			SET @SpeedViewName = 'ItemDetailV2';
			SET @TableName = @SpeedViewName;
			SET @TableNameNew = @TableName + '_New';
			SET @TableNamePrevious = @TableName + '_Previous';
			SET @TableNameCurrentWithSchema = '[' + @Schema + '].[' + @TableNameNew + ']';
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNameNew)
			BEGIN
				SET @Sql = 'DROP TABLE ' + @TableNameCurrentWithSchema;
				EXEC(@Sql);
				SET @MessageText = 'Dropped table ' + @TableNameCurrentWithSchema;
				EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			END;
			SET @BatchSize = 50;
			SET @BatchIndex = 1;
			SELECT @CountItems = COUNT(*) FROM @ItemIds;
			SET @CountBatches = CEILING(@CountItems / @BatchSize);
			IF @CountBatches = 0 SET @CountBatches = 1;
			SET @MessageText = 'Starting batched pulls of size ' + CAST(@BatchSize AS VARCHAR) + ' into ' + @TableNameCurrentWithSchema + ' from speed view ' + @SpeedViewName;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			WHILE (@BatchIndex = 1 OR EXISTS (SELECT * FROM @ItemIds))
			BEGIN
				INSERT INTO @BatchItemIds SELECT TOP (@BatchSize) * FROM @ItemIds;
				SET @CountBatchIds = @@ROWCOUNT;
				SELECT @ItemIdIn = [stage].[ToDelimitedString](@BatchItemIds, ',', '''''');
				SET @Columns = '"ItemId", "ItemDsc", "ItemFullDsc", "CommodityCd", "ItemClassNm", "ItemRevisionId", "EffectiveRevisionCd", "CurrentRevisionCd", "ItemOwningSystemNm", "MakeBuyNm", "NetWeightQty", "UnitOfMeasureCd", "MaterialTypeCd", "GrossWeightQty", "UnitOfWeightDim", "GlobalTradeIdentifierNbr", "BusinessUnitId", "BusinessUnitNm", "LastClassChangeDt", "OwningSystemLastModificationDtm", "CreateAgentId", "CreateDtm", "ChangeAgentId", "ChangeDtm"';
				IF (@BatchIndex = 1)
				BEGIN
					SET @Sql = 'SELECT GETUTCDATE() AS PullDateTime, * INTO ' + @TableNameCurrentWithSchema + ' FROM OPENQUERY (' + @LinkedServer + ', ''SELECT ' + @Columns + ' FROM "' + @SpeedViewName + '" WHERE "ItemId" IN (' + @ItemIdIn + ')'')';
				END;
				ELSE
				BEGIN
					SET @Sql = 'INSERT INTO ' + @TableNameCurrentWithSchema + ' SELECT GETUTCDATE() AS PullDateTime, * FROM OPENQUERY (' + @LinkedServer + ', ''SELECT ' + @Columns + ' FROM "' + @SpeedViewName + '" WHERE "ItemId" IN (' + @ItemIdIn + ')'')';
				END;
				EXEC(@Sql);
				SET @Count = @@ROWCOUNT;
				SET @MessageText = @SpeedViewName + ': Pulled batch ' + CAST(@BatchIndex AS VARCHAR) + ' of ' + CAST(@CountBatches AS VARCHAR) + ' containing ' + CAST(@Count AS VARCHAR) + ' record(s)';
				SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * @BatchIndex / @CountBatches);
				EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
				DELETE FROM @ItemIds WHERE [Value] IN (SELECT * FROM @BatchItemIds);
				DELETE FROM @BatchItemIds;
				SET @BatchIndex = @BatchIndex + 1;
			END;
			SET @MessageText = 'Completed batched data pulls into ' + @TableNameCurrentWithSchema + ' from speed view ' + @SpeedViewName;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			SET @Sql = 'ALTER TABLE ' + @TableNameCurrentWithSchema + ' ALTER COLUMN [ItemId] nvarchar(21) NOT NULL';
			EXEC(@Sql);
			SET @Sql = 'ALTER TABLE ' + @TableNameCurrentWithSchema + ' ADD PRIMARY KEY ([ItemId])';
			EXEC(@Sql);
			SET @Sql = 'CREATE INDEX IX_ItemDsc ON ' + @TableNameCurrentWithSchema + ' ([ItemDsc])';
			EXEC(@Sql);
			SET @Sql = 'CREATE INDEX IX_CommodityCd ON ' + @TableNameCurrentWithSchema + ' ([CommodityCd])';
			EXEC(@Sql);
			SET @Sql = 'CREATE INDEX IX_ItemClassNm ON ' + @TableNameCurrentWithSchema + ' ([ItemClassNm])';
			EXEC(@Sql);
			SET @Sql = 'CREATE INDEX IX_MaterialTypeCd ON ' + @TableNameCurrentWithSchema + ' ([MaterialTypeCd])';
			EXEC(@Sql);
			INSERT INTO @Tables VALUES (@TableId, @TableNameNew, @TableName, @TableNamePrevious);
		END;

		-- Step 5B: ItemCharacteristicV2
		IF (@IncludeItemCharacteristics = 1)
		BEGIN
			DELETE FROM @ItemIds;
			INSERT INTO @ItemIds SELECT * FROM @ConsolidatedItemIds;

			SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
			SET @ProgressSubtaskRange = 24;
			EXEC [stage].[UpdateTaskProgress] @TaskId, @ProgressSubtaskInitial, 'Preparing to pull ItemCharacteristicV2 data';
			SET @TableId = @TableId + 1;
			SET @SpeedViewName = 'ItemCharacteristicV2';
			SET @TableName = @SpeedViewName;
			SET @TableNameNew = @TableName + '_New';
			SET @TableNamePrevious = @TableName + '_Previous';
			SET @TableNameCurrentWithSchema = '[' + @Schema + '].[' + @TableNameNew + ']';
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNameNew)
			BEGIN
				SET @Sql = 'DROP TABLE ' + @TableNameCurrentWithSchema;
				EXEC(@Sql);
				SET @MessageText = 'Dropped table ' + @TableNameCurrentWithSchema;
				EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			END;
			SET @BatchSize = 20;
			SET @BatchIndex = 1;
			SELECT @CountItems = COUNT(*) FROM @ItemIds;
			SET @CountBatches = CEILING(@CountItems / @BatchSize);
			IF @CountBatches = 0 SET @CountBatches = 1;
			SET @MessageText = 'Starting batched data pulls of size ' + CAST(@BatchSize AS VARCHAR) + ' into ' + @TableNameCurrentWithSchema + ' from speed view ' + @SpeedViewName;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			WHILE (@BatchIndex = 1 OR EXISTS (SELECT * FROM @ItemIds))
			BEGIN
				INSERT INTO @BatchItemIds SELECT TOP (@BatchSize) * FROM @ItemIds;
				SET @CountBatchIds = @@ROWCOUNT;
				SELECT @ItemIdIn = [stage].[ToDelimitedString](@BatchItemIds, ',', '''''');
				SET @Columns = '"ItemId", "CharacteristicId", "CharacteristicNm", "CharacteristicDsc", "CharacteristicValueTxt", "CharacteristicSequenceNbr", "CharacteristicLastModifiedDt", "CharacteristicLastModifiedUsr", "CreateAgentId", "CreateDtm", "ChangeAgentId", "ChangeDtm"';
				IF (@BatchIndex = 1)
				BEGIN
					SET @Sql = 'SELECT GETUTCDATE() AS PullDateTime, * INTO ' + @TableNameCurrentWithSchema + ' FROM OPENQUERY (' + @LinkedServer + ', ''SELECT ' + @Columns + ' FROM "' + @SpeedViewName + '" WHERE "ItemId" IN (' + @ItemIdIn + ')'')'; --AND "CharacteristicNm" IN (''''MARKET_CODE_NAME'''', ''''MODEL_STRING_NAME'''', ''''MM-ITEM-MARKET-NAME'''', ''''MM-CUST-CUSTOMER'''')
				END;
				ELSE
				BEGIN
					SET @Sql = 'INSERT INTO ' + @TableNameCurrentWithSchema + ' SELECT GETUTCDATE() AS PullDateTime, * FROM OPENQUERY (' + @LinkedServer + ', ''SELECT ' + @Columns + ' FROM "' + @SpeedViewName + '" WHERE "ItemId" IN (' + @ItemIdIn + ')'')';
				END;
				EXEC(@Sql);
				SET @Count = @@ROWCOUNT;
				SET @MessageText = @SpeedViewName + ': Pulled batch ' + CAST(@BatchIndex AS VARCHAR) + ' of ' + CAST(@CountBatches AS VARCHAR) + ' containing ' + CAST(@Count AS VARCHAR) + ' record(s)';
				SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * @BatchIndex / @CountBatches);
				EXEC [stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
				DELETE FROM @ItemIds WHERE [Value] IN (SELECT * FROM @BatchItemIds);
				DELETE FROM @BatchItemIds;
				SET @BatchIndex = @BatchIndex + 1;
			END;
			SET @MessageText = 'Completed batched data pulls into ' + @TableNameCurrentWithSchema + ' from speed view ' + @SpeedViewName;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			--SET @Sql = 'ALTER TABLE ' + @TableNameCurrentWithSchema + ' ALTER COLUMN [ItemId] nvarchar(21) NOT NULL';
			--EXEC(@Sql);
			SET @Sql = 'CREATE INDEX IX_ItemId ON ' + @TableNameCurrentWithSchema + ' ([ItemId])';
			EXEC(@Sql);
			SET @Sql = 'CREATE INDEX IX_CharacteristicId ON ' + @TableNameCurrentWithSchema + ' ([CharacteristicId])';
			EXEC(@Sql);
			SET @Sql = 'CREATE INDEX IX_CharacteristicNm ON ' + @TableNameCurrentWithSchema + ' ([CharacteristicNm])';
			EXEC(@Sql);
			INSERT INTO @Tables VALUES (@TableId, @TableNameNew, @TableName, @TableNamePrevious);
		END;

		SET @MaxTableId = @TableId;

		-- Step 6: Rename tables
		-- only after we get to this point do we proceed with renaming tables
		-- this is to ensure all steps above have been completed successfully
		-- if anything goes wrong above, this step will not occur and the existing tables will still be in place and consistent (although potentially out of date)
		SET @ProgressSubtaskInitial = @ProgressSubtaskInitial + @ProgressSubtaskRange;
		SET @ProgressSubtaskRange = 1;
		EXEC [stage].[UpdateTaskProgress] @TaskId, @ProgressSubtaskInitial, 'Renaming tables';
		SET @TableId = 1;
		WHILE @TableId <= @MaxTableId
		BEGIN
			SELECT @TableNameNew = [TableNameNew], @TableName = [TableName], @TableNamePrevious = [TableNamePrevious] FROM @Tables WHERE [Id] = @TableId;

			-- Drop *_Previous table if it exists
			SET @TableNameCurrentWithSchema = '[' + @Schema + '].[' + @TableNamePrevious + ']';
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableNamePrevious)
			BEGIN
				SET @Sql = 'DROP TABLE ' + @TableNameCurrentWithSchema;
				EXEC(@Sql);
				SET @MessageText = 'Dropped table ' + @TableNameCurrentWithSchema;
				EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			END;

			-- Rename * table to *_Previous
			SET @TableNameCurrentWithSchema = '[' + @Schema + '].[' + @TableName + ']';
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableName)
			BEGIN
				EXEC sp_rename @TableNameCurrentWithSchema, @TableNamePrevious;
				SET @MessageText = 'Renamed table ' + @TableName + ' to ' + @TableNamePrevious;
				EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			END;

			-- Rename *_New table to *
			SET @TableNameCurrentWithSchema = '[' + @Schema + '].[' + @TableNameNew + ']';
			EXEC sp_rename @TableNameCurrentWithSchema, @TableName;
			SET @MessageText = 'Renamed table ' + @TableNameNew + ' to ' + @TableName;
			EXEC [stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

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
