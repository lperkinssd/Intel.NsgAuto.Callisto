-- ===================================================
-- Author       : bricschx
-- Create date  : 2020-10-22 12:51:55.507
-- Description  : Task for creating MM recipes
-- Example      : EXEC [qan].[TaskCreateMMRecipes];
-- ===================================================
CREATE PROCEDURE [qan].[TaskCreateMMRecipes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText NVARCHAR(4000);
	DECLARE @TaskId BIGINT;

	BEGIN TRY

		EXEC [CallistoCommon].[stage].[CreateTaskByName] @TaskId OUTPUT, 'Create MM Recipes';

		DECLARE @By VARCHAR(25) = [qan].[CreatedByTask](@TaskId);
		DECLARE @Count INT = 0;
		DECLARE @PCodes [qan].[IPCodes];
		DECLARE @ProgressSubtaskInitial TINYINT = 0;
		DECLARE @ProgressSubtaskRange TINYINT = 0;
		DECLARE @Progress TINYINT = 0;

		SET @MessageText = 'Determining all pcodes to check for differences against newest data available';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 0, @MessageText;
		INSERT INTO @PCodes SELECT [PCode] FROM [CallistoCommon].[stage].[PCodes] WITH (NOLOCK) WHERE [IncludeMMRecipes] = 1 AND [PCode] IN (SELECT [PCode] FROM [CallistoCommon].[stage].[SpeedMMRecipes] WITH (NOLOCK));
		DELETE FROM @PCodes WHERE [PCode] IN (SELECT [RootItemId] FROM [CallistoCommon].[stage].[SpeedMMRecipes] WITH (NOLOCK) WHERE [SCode] IS NULL OR ([RootItemId] != [PCode]));
		SELECT @Count = @@ROWCOUNT;
		SET @MessageText = 'Total pcodes that will be skipped due to insufficient tree data: ' + CAST(@Count AS VARCHAR(20));
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		SELECT @Count = COUNT(*) FROM @PCodes;
		SET @MessageText = 'Total pcodes to check for differences: ' + CAST(@Count AS VARCHAR(20));
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;


		DECLARE @MMRecipes1 [qan].[IMMRecipesCompare]; -- generated speed data
		DECLARE @MMRecipes2 [qan].[IMMRecipesCompare]; -- native system data
		DECLARE @AssociatedItems1 [qan].[IMMRecipeAssociatedItemsCompare]; -- generated speed data
		DECLARE @AssociatedItems2 [qan].[IMMRecipeAssociatedItemsCompare]; -- native system data

		SET @MessageText = 'Generating speed comparison data';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 5, @MessageText;

		INSERT INTO @MMRecipes1 ([Id], [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId])
		SELECT NULL, [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId]
		FROM [qan].[FMMRecipesNewCore](@PCodes);

		INSERT INTO @AssociatedItems1 ([PCode], [ItemId], [Id], [MATId], [SpeedItemCategoryId], [Revision], [SpeedBomAssociationTypeId])
		SELECT [PCode], [ItemId], NULL, [MATId], [SpeedItemCategoryId], [Revision], [SpeedBomAssociationTypeId]
		FROM [qan].[FMMRecipesAssociatedItemsNewCore](@PCodes);

		SET @MessageText = 'Generated speed comparison data';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;


		SET @MessageText = 'Gathering native system data';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 15, @MessageText;

		-- get only the latest (i.e. highest id) mm recipes in an appropriate status
		INSERT INTO @MMRecipes2 ([Id], [PCode], [ProductName], [ProductFamilyId], [MOQ], [ProductionProductCode], [SCode], [FormFactorId], [CustomerId], [PRQDate], [CustomerQualStatusId], [SCodeProductCode], [ModelString], [PLCStageId], [ProductLabelId])
		SELECT M.[Id], M.[PCode], M.[ProductName], M.[ProductFamilyId], M.[MOQ], M.[ProductionProductCode], M.[SCode], M.[FormFactorId], M.[CustomerId], M.[PRQDate], M.[CustomerQualStatusId], M.[SCodeProductCode], M.[ModelString], M.[PLCStageId], M.[ProductLabelId]
		FROM [qan].[MMRecipes] AS M WITH (NOLOCK) INNER JOIN @PCodes AS P ON (P.[PCode] = M.[PCode])
		WHERE [Id] IN (SELECT MAX(M2.[Id]) AS [MaxId] FROM [qan].[MMRecipes] AS M2 WITH (NOLOCK) INNER JOIN [ref].[Statuses] AS S WITH (NOLOCK) ON (S.[Id] = M2.[StatusId]) WHERE S.[Name] IN ('Complete', 'Draft', 'In Review', 'Submitted') GROUP BY M2.[PCode]);

		INSERT INTO @AssociatedItems2 ([PCode], [ItemId], [Id], [MATId], [SpeedItemCategoryId], [Revision], [SpeedBomAssociationTypeId])
		SELECT M.[PCode], I.[ItemId], I.[Id], I.[MATId], I.[SpeedItemCategoryId], I.[Revision], I.[SpeedBomAssociationTypeId]
		FROM @MMRecipes2 AS M INNER JOIN [qan].[MMRecipeAssociatedItems] AS I WITH (NOLOCK) ON (I.[MMRecipeId] = M.[Id]);

		SET @MessageText = 'Gathered native system data';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		DECLARE @ComparisonResults TABLE
		(
			  [EntityType]       VARCHAR(50)
			, [PCode]            VARCHAR(10)
			, [ItemId]           VARCHAR(21)
			, [AttributeTypeId]  INT
			, [MissingFrom]      TINYINT
			, [Id1]              BIGINT
			, [Id2]              BIGINT
			, [Field]            VARCHAR(100)
			, [Different]        BIT
			, [Value1]           VARCHAR(MAX)
			, [Value2]           VARCHAR(MAX)
			, INDEX [IX_EntityType] ([EntityType])
			, INDEX [IX_PCode] ([PCode])
		);

		SET @MessageText = 'Comparing the two data sets';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 25, @MessageText;

		INSERT INTO @ComparisonResults
		(
			  [EntityType]
			, [PCode]
			, [ItemId]
			, [AttributeTypeId]
			, [MissingFrom]
			, [Id1]
			, [Id2]
			, [Field]
			, [Different]
			, [Value1]
			, [Value2]
		)
		SELECT
			  [EntityType]
			, [PCode]
			, [ItemId]
			, [AttributeTypeId]
			, [MissingFrom]
			, [Id1]
			, [Id2]
			, [Field]
			, [Different]
			, [Value1]
			, [Value2]
		FROM [qan].[FCompareMMRecipes](@MMRecipes1, @MMRecipes2, @AssociatedItems1, @AssociatedItems2)
		WHERE ([MissingFrom] IS NOT NULL OR [Different] = 1)
		  AND ([Field] IS NULL
				OR (NOT ([EntityType] = 'MMRecipe' AND [Field] IN ('ProductLabelId', 'PRQDate', 'CustomerQualStatusId', 'PLCStageId')) -- differences in ProductLabelIds are okay (the underlying data differences are the important part); others are user input fields
					AND NOT ([EntityType] = 'MMRecipeAssociatedItem' AND [Field] = 'MATId') -- differences in MATIds are okay (the underlying data differences are the important part)
				   )
			  );

		DECLARE @CountPCodesWithDifferences INT;
		DECLARE @PCodesWithDifferences [qan].[IPCodes];
		INSERT INTO @PCodesWithDifferences SELECT DISTINCT [PCode] FROM @ComparisonResults;
		SELECT @CountPCodesWithDifferences = @@ROWCOUNT;

		SET @MessageText = 'Total pcodes with differences: ' + CAST(@CountPCodesWithDifferences AS VARCHAR(20));
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;


		SET @ProgressSubtaskInitial = 50;
		SET @ProgressSubtaskRange = 50;
		SET @MessageText = 'Creating new MM recipes';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, @ProgressSubtaskInitial, @MessageText;

		DECLARE @StatusIdCanceled INT;
		SELECT @StatusIdCanceled = [Id] FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Canceled';
		DECLARE @StatusIdsToCancel [qan].[IInts];
		INSERT INTO @StatusIdsToCancel SELECT [Id] FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] IN ('Draft', 'In Review', 'Submitted');
		DECLARE @PCode VARCHAR(10);
		DECLARE @Id BIGINT;
		DECLARE @Index INT = 0;
		WHILE (EXISTS (SELECT * FROM @PCodesWithDifferences))
		BEGIN
			SET @Index = @Index + 1;
			SELECT TOP 1 @PCode = [PCode] FROM @PCodesWithDifferences;
			SELECT @Id = MAX([Id]) FROM @MMRecipes2 WHERE [PCode] = @PCode;
			IF (@Id IS NOT NULL)
			BEGIN
				-- only cancel if currently in appropriate status
				UPDATE [qan].[MMRecipes] SET [StatusId] = @StatusIdCanceled, [UpdatedBy] = @By, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id AND [StatusId] IN (SELECT [Value] FROM @StatusIdsToCancel);
				SELECT @Count = @@ROWCOUNT;
				IF (@Count > 0)
				BEGIN
					SET @MessageText = 'Canceled MM Recipe with Id = ' + CAST(@Id AS VARCHAR(20));
					EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
				END;
			END;
			EXEC [qan].[CreateMMRecipe] @Id OUT, @By, @PCode;
			SET @MessageText = 'Created MM Recipe for pcode = ' + @PCode + ' with Id = ' + CAST(@Id AS VARCHAR(20));
			EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
			SET @MessageText = 'Creating MM recipes: ' + CAST(@Index AS VARCHAR(20)) + ' of ' + CAST(@CountPCodesWithDifferences AS VARCHAR(20));
			SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * @Index / @CountPCodesWithDifferences);
			EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
			DELETE FROM @PCodesWithDifferences WHERE [PCode] = @PCode;
		END;

		SET @MessageText = 'Total MM recipes created: ' + CAST(@Index AS VARCHAR(20));
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

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
