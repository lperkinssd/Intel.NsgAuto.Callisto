-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-29 13:26:58.837
-- Description  : Task for synchronizing auto checker build criteria data with treadstone
-- Example      : EXEC [qan].[TaskSyncTreadstoneAcBuildCriterias];
-- ======================================================================================
CREATE PROCEDURE [qan].[TaskSyncTreadstoneAcBuildCriterias]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MessageText NVARCHAR(4000);
	DECLARE @TaskId BIGINT;

	BEGIN TRY

		EXEC [CallistoCommon].[stage].[CreateTaskByName] @TaskId OUTPUT, 'Sync Treadstone Auto Checker Build Criterias';

		DECLARE @By                     VARCHAR(25) = [qan].[CreatedByTask](@TaskId);
		DECLARE @Count                  INT = 0;
		DECLARE @Errors                 INT = 0;
		DECLARE @Progress               TINYINT = 0;
		DECLARE @ProgressSubtaskInitial TINYINT = 0;
		DECLARE @ProgressSubtaskRange   TINYINT = 0;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 0, 'Creating new designs';
		EXEC [qan].[CreateNewTreadstoneDesigns] @Count OUTPUT, @By;
		SET @MessageText = 'New designs inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 8, 'Creating new fabrication facilities';
		EXEC [qan].[CreateNewTreadstoneFabricationFacilities] @Count OUTPUT, @By;
		SET @MessageText = 'New fabrication facilities inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 16, 'Creating new test flows';
		EXEC [qan].[CreateNewTreadstoneTestFlows] @Count OUTPUT, @By;
		SET @MessageText = 'New test flows inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 24, 'Creating new probe conversions';
		EXEC [qan].[CreateNewTreadstoneProbeConversions] @Count OUTPUT, @By;
		SET @MessageText = 'New probe conversions inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 32, 'Creating new build combinations';
		EXEC [qan].[CreateNewTreadstoneAcBuildCombinations] @Count OUTPUT, @By;
		SET @MessageText = 'New build combinations inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 40, 'Creating new attribute types';
		EXEC [qan].[CreateNewTreadstoneAttributeTypes] @Count OUTPUT, @By;
		SET @MessageText = 'New attribute types inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 48, 'Creating new attribute type values';
		EXEC [qan].[CreateNewTreadstoneAttributeTypeValues] @Count OUTPUT, @By;
		SET @MessageText = 'New attribute type values inserted: ' + CAST(@Count AS VARCHAR);
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		DECLARE @BuildCriterias1 [qan].[IAcBuildCriteriasCompare];      -- generated treadstone data
		DECLARE @BuildCriterias2 [qan].[IAcBuildCriteriasCompare];      -- native system data
		DECLARE @Conditions1 [qan].[IAcBuildCriteriaConditionsCompare]; -- generated treadstone data
		DECLARE @Conditions2 [qan].[IAcBuildCriteriaConditionsCompare]; -- native system data

		SET @MessageText = 'Gathering treadstone comparison data';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 55, @MessageText;

		SELECT S.[BuildRuleId], BC.[Id] AS [BuildCombinationId], P.[Id] AS [DesignId], FF.[Id] AS [FabricationFacilityId], TF.[Id] AS [TestFlowId], PC.[Id] AS [ProbeConversionId]
		INTO #BuildRules
		FROM
		(
		 SELECT [build_rule_id] AS [BuildRuleId], UPPER(NULLIF(LTRIM(RTRIM([design_id])), '')) AS [DesignName], UPPER(NULLIF(LTRIM(RTRIM([fabrication_facility])), '')) AS [FabricationFacilityName], UPPER(NULLIF(LTRIM(RTRIM([test_flow])), '')) AS [TestFlowName], UPPER(NULLIF(LTRIM(RTRIM([prb_conv_id])), '')) AS [ProbeConversionName] FROM [TREADSTONE].[treadstone].[dbo].[build_rule] WITH (NOLOCK) WHERE NULLIF(LTRIM(RTRIM([design_id])), '') IS NOT NULL AND NULLIF(LTRIM(RTRIM([fabrication_facility])), '') IS NOT NULL
		) AS S
		INNER JOIN [qan].[Products] AS P WITH (NOLOCK) ON (P.[Name] = S.[DesignName])
		INNER JOIN [qan].[FabricationFacilities] AS FF WITH (NOLOCK) ON (FF.[Name] = S.[FabricationFacilityName])
		LEFT OUTER JOIN [qan].[TestFlows] AS TF WITH (NOLOCK) ON (TF.[Name] = S.[TestFlowName])
		LEFT OUTER JOIN [qan].[ProbeConversions] AS PC WITH (NOLOCK) ON (PC.[Name] = S.[ProbeConversionName])
		INNER JOIN [qan].[AcBuildCombinations] AS BC WITH (NOLOCK)
		ON
		(
				BC.[DesignId] = P.[Id]
			AND BC.[FabricationFacilityId] = FF.[Id]
			AND (BC.[TestFlowId] = TF.[Id] OR (BC.[TestFlowId] IS NULL AND TF.[Id] IS NULL))
			AND (BC.[ProbeConversionId] = PC.[Id] OR (BC.[ProbeConversionId] IS NULL AND PC.[Id] IS NULL))
		);

		SELECT S.[BuildRuleConditionId], S.[BuildRuleId], BR.[BuildCombinationId], A.[Id] AS [AttributeTypeId], S.[AttributeTypeName], CO.[Id] AS [ComparisonOperationId], CO.[Key] AS [ComparisonOperationKey], CO.[KeyTreadstone] AS [ComparisonOperationKeyTreadstone], S.[Value]
		INTO #BuildRuleConditions
		FROM 
		(
			SELECT [build_rule_condition_id] AS [BuildRuleConditionId], [build_rule_id] AS [BuildRuleId], [column_name] AS [AttributeTypeName], [operator] AS [ComparisonOperationKeyTreadstone], [column_value] AS [Value] FROM [TREADSTONE].[treadstone].[dbo].[build_rule_condition] WITH (NOLOCK)
		) AS S
		INNER JOIN #BuildRules AS BR WITH (NOLOCK) ON (BR.[BuildRuleId] = S.[BuildRuleId])
		LEFT OUTER JOIN [qan].[AcAttributeTypes] AS A WITH (NOLOCK) ON (A.[Name] = S.[AttributeTypeName])
		LEFT OUTER JOIN [ref].[AcComparisonOperations] AS CO WITH (NOLOCK) ON (CO.[KeyTreadstone] = S.[ComparisonOperationKeyTreadstone]);

		INSERT INTO @BuildCriterias1 ([BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId])
		SELECT [BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId] FROM #BuildRules;

		INSERT INTO @Conditions1 ([BuildCombinationId], [AttributeTypeId], [ComparisonOperationId], [Value])
		SELECT [BuildCombinationId], [AttributeTypeId], [ComparisonOperationId], [Value] FROM #BuildRuleConditions;

		SET @MessageText = 'Gathered treadstone comparison data';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		SET @MessageText = 'Gathering native system data (POR)';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 60, @MessageText;

		-- get only PRQ data (i.e. [IsPOR] = 1)
		INSERT INTO @BuildCriterias2 ([Id], [BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId])
		SELECT [Id], [BuildCombinationId], [DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId]
		FROM [qan].[AcBuildCriterias] WITH (NOLOCK) WHERE [IsPOR] = 1;

		INSERT INTO @Conditions2 ([BuildCombinationId], [AttributeTypeId], [ComparisonOperationId], [Value])
		SELECT B.[BuildCombinationId], C.[AttributeTypeId], C.[ComparisonOperationId], C.[Value]
		FROM @BuildCriterias2 AS B INNER JOIN [qan].[AcBuildCriteriaConditions] AS C WITH (NOLOCK) ON (C.[BuildCriteriaId] = B.[Id]);

		SET @MessageText = 'Gathered native system data (POR)';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		DECLARE @ComparisonResults TABLE
		(
			  [EntityType]             VARCHAR(50)
			, [BuildCombinationId]     INT
			, [AttributeTypeId]        INT
			, [ComparisonOperationId]  INT
			, [MissingFrom]            TINYINT
			, [Id1]                    BIGINT
			, [Id2]                    BIGINT
			, [Field]                  VARCHAR(100)
			, [Different]              BIT
			, [Value1]                 VARCHAR(MAX)
			, [Value2]                 VARCHAR(MAX)
			, INDEX [IX_EntityType] ([EntityType])
			, INDEX [IX_BuildCombinationId] ([BuildCombinationId])
		);

		SET @MessageText = 'Comparing the two data sets';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, 65, @MessageText;

		INSERT INTO @ComparisonResults
		(
			  [EntityType]
			, [BuildCombinationId]
			, [AttributeTypeId]
			, [ComparisonOperationId]
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
			, [BuildCombinationId]
			, [AttributeTypeId]
			, [ComparisonOperationId]
			, [MissingFrom]
			, [Id1]
			, [Id2]
			, [Field]
			, [Different]
			, [Value1]
			, [Value2]
		FROM [qan].[FCompareAcBuildCriterias](@BuildCriterias1, @BuildCriterias2, @Conditions1, @Conditions2)
		WHERE ([MissingFrom] IS NOT NULL OR [Different] = 1)
		  AND ([Field] IS NULL
				OR (NOT ([EntityType] = 'AcBuildCriteria' AND [Field] IN ('EffectiveOn'))) -- user input fields
			  );

		DECLARE @CountCombinationsWithDifferences INT;
		DECLARE @CombinationsWithDifferences TABLE ([Id] INT NOT NULL);
		INSERT INTO @CombinationsWithDifferences SELECT DISTINCT [BuildCombinationId] FROM @ComparisonResults;
		SELECT @CountCombinationsWithDifferences = @@ROWCOUNT;

		SET @MessageText = 'Total build combinations with differences: ' + CAST(@CountCombinationsWithDifferences AS VARCHAR(20));
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;


		SET @ProgressSubtaskInitial = 70;
		SET @ProgressSubtaskRange = 30;
		SET @MessageText = 'Creating new build criterias';
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
		EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, @ProgressSubtaskInitial, @MessageText;

		DECLARE @BuildCombinationId    INT;
		DECLARE @Conditions            [qan].[IAcBuildCriteriaConditionsCreate];
		DECLARE @DesignId              INT;
		DECLARE @FabricationFacilityId INT;
		DECLARE @Id                    BIGINT;
		DECLARE @IdPrevious            BIGINT;
		DECLARE @Index                 INT = 0;
		DECLARE @Message               VARCHAR(500);
		DECLARE @ProbeConversionId     INT;
		DECLARE @TestFlowId            INT;
		WHILE (EXISTS (SELECT * FROM @CombinationsWithDifferences))
		BEGIN
			SET @Index = @Index + 1;
			SELECT TOP 1 @BuildCombinationId = [Id] FROM @CombinationsWithDifferences;
			SELECT
				  @DesignId              = MAX([DesignId])
				, @FabricationFacilityId = MAX([FabricationFacilityId])
				, @TestFlowId            = MAX([TestFlowId])
				, @ProbeConversionId     = MAX([ProbeConversionId])
			FROM [qan].[AcBuildCombinations] WITH (NOLOCK) WHERE [Id] = @BuildCombinationId;
			DELETE FROM @Conditions;
			INSERT INTO @Conditions ([Index], [AttributeTypeName], [ComparisonOperationKey], [Value])
			SELECT
				  ROW_NUMBER() OVER(ORDER BY [AttributeTypeName], [ComparisonOperationKeyTreadstone], [Value]) AS [Index]
				, [AttributeTypeName]
				, [ComparisonOperationKey]
				, [Value]
			FROM #BuildRuleConditions WHERE [BuildCombinationId] = @BuildCombinationId;
			EXEC [qan].[CreateAcBuildCriteria] @Id OUT, @Message OUT, @By, @DesignId, @FabricationFacilityId, @TestFlowId, @ProbeConversionId, @Conditions, 'Pulled from Treadstone', 1, 0;
			IF (@Id IS NOT NULL)
			BEGIN
				SET @MessageText = 'Created build criteria for build combination id = ' + CAST(@BuildCombinationId AS VARCHAR(20)) + ' with Id = ' + CAST(@Id AS VARCHAR(20));
				EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
				SELECT @IdPrevious = MAX([Id]) FROM @BuildCriterias2 WHERE [BuildCombinationId] = @BuildCombinationId;
				IF (@IdPrevious IS NOT NULL)
				BEGIN
					SET @Count = 0;
					-- unset POR for previous version
					UPDATE [qan].[AcBuildCriterias] SET [IsPOR] = 0, [UpdatedBy] = @By, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @IdPrevious AND [IsPOR] = 1;
					SELECT @Count = @@ROWCOUNT;
					IF (@Count > 0)
					BEGIN
						SET @MessageText = 'Set IsPOR = 0 for build criteria with Id = ' + CAST(@IdPrevious AS VARCHAR(20));
						EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;
					END;
				END;
				-- set POR and status for new version
				UPDATE [qan].[AcBuildCriterias] SET [IsPOR] = 1, [StatusId] = 6 WHERE [Id] = @Id; -- StatusId 6 = Complete
			END
			ELSE
			BEGIN
				SET @Errors = @Errors + 1;
				SET @MessageText = 'Could not create build criteria for build combination id = ' + CAST(@BuildCombinationId AS VARCHAR(20));
				IF (@Message IS NOT NULL) SET @MessageText = @MessageText + '; ' + @Message;
				EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Error', @MessageText;
			END;
			SET @MessageText = 'Creating build criterias: ' + CAST(@Index AS VARCHAR(20)) + ' of ' + CAST(@CountCombinationsWithDifferences AS VARCHAR(20));
			SET @Progress = @ProgressSubtaskInitial + (@ProgressSubtaskRange * @Index / @CountCombinationsWithDifferences);
			EXEC [CallistoCommon].[stage].[UpdateTaskProgress] @TaskId, @Progress, @MessageText;
			DELETE FROM @CombinationsWithDifferences WHERE [Id] = @BuildCombinationId;
		END;

		SET @MessageText = 'Total build criterias created: ' + CAST(@Index AS VARCHAR(20));
		EXEC [CallistoCommon].[stage].[CreateTaskMessage] @TaskId, 'Information', @MessageText;

		DROP TABLE #BuildRules;
		DROP TABLE #BuildRuleConditions;

		IF (@Errors > 0)
		BEGIN
			SET @MessageText = 'Finished with non-zero error count = ' + CAST(@Errors AS VARCHAR(20));
			THROW 50000, @MessageText, 1;
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