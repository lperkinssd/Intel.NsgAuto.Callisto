-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-02 12:16:37.843
-- Description  : Creates the initial review associations for the following tables:
--                [qan].[ReviewTypeReviewStages]
--                [qan].[ReviewStageReviewGroups]
--                [qan].[ReviewGroupReviewers]
--                Make sure @Environment is set correctly
-- Note         : The following scripts should be executed before this one:
--                [setup].[CreateInitialReviewStages]
--                [setup].[CreateInitialReviewGroups]
--                [setup].[CreateInitialReviewers]
-- Example      : EXEC [setup].[CreateInitialReviewTableAssociations] 'bricschx', 'dev';
--                SELECT * FROM [qan].[ReviewTypeReviewStages];
--                SELECT * FROM [qan].[ReviewStageReviewGroups];
--                SELECT * FROM [qan].[ReviewGroupReviewers];
-- ======================================================================================
CREATE PROCEDURE [setup].[CreateInitialReviewTableAssociations]
(
	  @By            VARCHAR(25) = NULL
	, @Environment   VARCHAR(5)  = 'prod'
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Associations TABLE
	(
		  [ReviewTypeId]             INT          NOT NULL
		, [ReviewTypeDescription]    VARCHAR(50)  NOT NULL
		, [ReviewStageId]            INT          NOT NULL
		, [ReviewStageName]          VARCHAR(100) NOT NULL
		, [ReviewGroupId]            INT          NOT NULL
		, [ReviewGroupName]          VARCHAR(50)  NOT NULL
		, [ReviewerId]               INT          NOT NULL
		, [ReviewerIdsid]            VARCHAR(50)  NOT NULL
		, [ReviewTypeReviewStageId]  INT
		, [ReviewStageReviewGroupId] INT
		, [ReviewGroupReviewerId]    INT
	);
	DECLARE @Count INT = 0;
	DECLARE @InsertsReviewGroupReviewers TABLE
	(
		  [Id]                       INT NOT NULL
		, [ReviewStageReviewGroupId] INT NOT NULL
		, [ReviewerId]               INT NOT NULL
	);
	DECLARE @InsertsReviewStageReviewGroups TABLE
	(
		  [Id]                       INT NOT NULL
		, [ReviewTypeReviewStageId]  INT NOT NULL
		, [ReviewGroupId]            INT NOT NULL
	);
	DECLARE @InsertsReviewTypeReviewStages TABLE
	(
		  [Id]                       INT NOT NULL
		, [ReviewTypeId]             INT NOT NULL
		, [ReviewStageId]            INT NOT NULL
	);
	DECLARE @Message VARCHAR(MAX);
	DECLARE @Values TABLE
	(
		  [ReviewTypeDescription]    VARCHAR(50)  NOT NULL
		, [ReviewStageName]          VARCHAR(100) NOT NULL
		, [ReviewGroupName]          VARCHAR(50)  NOT NULL
		, [ReviewerIdsid]            VARCHAR(50)  NOT NULL
	);
	IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	IF (@Environment = 'prod')
	BEGIN
		INSERT INTO @Values ([ReviewTypeDescription], [ReviewStageName], [ReviewGroupName], [ReviewerIdsid])
		VALUES
			  ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'kkliou')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'arasheft')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'poojatiw')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'andrewdw')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'bcromo')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'kokhinte')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'coter')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'arasheft')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'poojatiw')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'gerritle')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'arasheft')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'poojatiw')
		;
	END
	ELSE IF (@Environment = 'int')
	BEGIN
		INSERT INTO @Values ([ReviewTypeDescription], [ReviewStageName], [ReviewGroupName], [ReviewerIdsid])
		VALUES
			  ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'arasheft')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'ldennis')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'coter')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'poojatiw')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'bricschx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'jakemurx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'jkurian')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'arasheft')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'ldennis')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'coter')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'poojatiw')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'bricschx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'jakemurx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'jkurian')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'arasheft')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'poojatiw')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'yunpengw')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'coter')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'tdclinto')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'bricschx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'jakemurx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'jkurian')
			, ('MM Recipe', 'Stage1', 'Group1', 'bricschx')
			, ('MM Recipe', 'Stage1', 'Group1', 'jakemurx')
			, ('MM Recipe', 'Stage1', 'Group1', 'jkurian')
			, ('MM Recipe', 'Stage1', 'Group1', 'snmohile')
			, ('MM Recipe', 'Stage1', 'Group1', 'llxu')
			, ('MM Recipe', 'Stage1', 'Group1', 'nkkhoury')
			, ('MM Recipe', 'Stage1', 'Group1', 'dodohert')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Media PE', 'arasheft')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Media PE', 'ldennis')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Media PE', 'coter')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Media PE', 'poojatiw')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Media PE', 'bricschx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Media PE', 'jakemurx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Media PE', 'jkurian')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Q & R', 'arasheft')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Q & R', 'ldennis')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Q & R', 'coter')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Q & R', 'poojatiw')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Q & R', 'bricschx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Q & R', 'jakemurx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Q & R', 'jkurian')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Supply Chain Planner', 'arasheft')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Supply Chain Planner', 'poojatiw')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Supply Chain Planner', 'yunpengw')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Supply Chain Planner', 'coter')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Supply Chain Planner', 'tdclinto')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Supply Chain Planner', 'bricschx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Supply Chain Planner', 'jakemurx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Supply Chain Planner', 'jkurian');
	END
	ELSE -- @Environment = 'dev'
	BEGIN
		INSERT INTO @Values ([ReviewTypeDescription], [ReviewStageName], [ReviewGroupName], [ReviewerIdsid])
		VALUES
			  ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'bricschx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'jakemurx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Media PE', 'jkurian')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'bricschx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'jakemurx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Q & R', 'jkurian')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'bricschx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'jakemurx')
			, ('Auto Checker Build Criteria NAND', 'HVM', 'Supply Chain Planner', 'jkurian')
			, ('MM Recipe', 'Stage1', 'Group1', 'bricschx')
			, ('MM Recipe', 'Stage1', 'Group1', 'jakemurx')
			, ('MM Recipe', 'Stage1', 'Group1', 'jkurian')
			, ('MM Recipe', 'Stage1', 'Group2', 'bricschx')
			, ('MM Recipe', 'Stage1', 'Group2', 'jakemurx')
			, ('MM Recipe', 'Stage1', 'Group2', 'jkurian')
			, ('MM Recipe', 'Stage2', 'Group3', 'bricschx')
			, ('MM Recipe', 'Stage2', 'Group3', 'jakemurx')
			, ('MM Recipe', 'Stage2', 'Group3', 'jkurian')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Media PE', 'bricschx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Media PE', 'jakemurx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Media PE', 'jkurian')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Q & R', 'bricschx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Q & R', 'jakemurx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Q & R', 'jkurian')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Supply Chain Planner', 'bricschx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Supply Chain Planner', 'jakemurx')
			, ('Osat Build Criteria Set NAND', 'HVM', 'Supply Chain Planner', 'jkurian');
	END;

	INSERT INTO @Associations
	(
		  [ReviewTypeId]
		, [ReviewTypeDescription]
		, [ReviewStageId]
		, [ReviewStageName]
		, [ReviewGroupId]
		, [ReviewGroupName]
		, [ReviewerId]
		, [ReviewerIdsid]
		, [ReviewTypeReviewStageId]
		, [ReviewStageReviewGroupId]
		, [ReviewGroupReviewerId]
	)
	SELECT
		  RT.[Id]
		, V.[ReviewTypeDescription]
		, RS.[Id]
		, V.[ReviewStageName]
		, RG.[Id]
		, V.[ReviewGroupName]
		, R.[Id]
		, V.[ReviewerIdsid]
		, RTRS.[Id]
		, RSRG.[Id]
		, RGR.[Id]
	FROM @Values AS V
	LEFT OUTER JOIN [ref].[ReviewTypes] AS RT WITH (NOLOCK) ON (RT.[Description] = V.[ReviewTypeDescription])
	LEFT OUTER JOIN [qan].[ReviewStages] AS RS WITH (NOLOCK) ON (RS.[StageName] = V.[ReviewStageName])
	LEFT OUTER JOIN [qan].[ReviewGroups] AS RG WITH (NOLOCK) ON (RG.[GroupName] = V.[ReviewGroupName])
	LEFT OUTER JOIN [qan].[Reviewers] AS R WITH (NOLOCK) ON (R.[Idsid] = V.[ReviewerIdsid])
	LEFT OUTER JOIN [qan].[ReviewTypeReviewStages] AS RTRS WITH (NOLOCK) ON (RTRS.[ReviewTypeId] = RT.[Id] AND RTRS.[ReviewStageId] = RS.[Id])
	LEFT OUTER JOIN [qan].[ReviewStageReviewGroups] AS RSRG WITH (NOLOCK) ON (RSRG.[ReviewTypeReviewStageId] = RTRS.[Id] AND RSRG.[ReviewGroupId] = RG.[Id])
	LEFT OUTER JOIN [qan].[ReviewGroupReviewers] AS RGR WITH (NOLOCK) ON (RGR.[ReviewStageReviewGroupId] = RSRG.[Id] AND RGR.[ReviewerId] = R.[Id]);

	-- [qan].[ReviewTypeReviewStages]
	INSERT INTO [qan].[ReviewTypeReviewStages]
	(
		  [ReviewTypeId]
		, [ReviewStageId]
		, [CreatedBy]
		, [UpdatedBy]
	)
	OUTPUT inserted.[Id], inserted.[ReviewTypeId], inserted.[ReviewStageId] INTO @InsertsReviewTypeReviewStages
	SELECT DISTINCT
		  [ReviewTypeId]
		, [ReviewStageId]
		, @By
		, @By
	FROM @Associations WHERE [ReviewTypeReviewStageId] IS NULL;

	UPDATE @Associations SET [ReviewTypeReviewStageId] = I.[Id]
	FROM @Associations AS A INNER JOIN @InsertsReviewTypeReviewStages AS I ON (I.[ReviewTypeId] = A.[ReviewTypeId] AND I.[ReviewStageId] = A.[ReviewStageId])
	WHERE A.[ReviewTypeReviewStageId] IS NULL;

	SELECT @Count = COUNT(*) FROM @InsertsReviewTypeReviewStages;
	SET @Message = '[qan].[ReviewTypeReviewStages] records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;

	-- [qan].[ReviewStageReviewGroups]
	INSERT INTO [qan].[ReviewStageReviewGroups]
	(
		  [ReviewTypeReviewStageId]
		, [ReviewGroupId]
		, [CreatedBy]
		, [UpdatedBy]
	)
	OUTPUT inserted.[Id], inserted.[ReviewTypeReviewStageId], inserted.[ReviewGroupId] INTO @InsertsReviewStageReviewGroups
	SELECT DISTINCT
		  [ReviewTypeReviewStageId]
		, [ReviewGroupId]
		, @By
		, @By
	FROM @Associations WHERE [ReviewStageReviewGroupId] IS NULL;

	UPDATE @Associations SET [ReviewStageReviewGroupId] = I.[Id]
	FROM @Associations AS A INNER JOIN @InsertsReviewStageReviewGroups AS I ON (I.[ReviewTypeReviewStageId] = A.[ReviewTypeReviewStageId] AND I.[ReviewGroupId] = A.[ReviewGroupId])
	WHERE A.[ReviewStageReviewGroupId] IS NULL;

	SELECT @Count = COUNT(*) FROM @InsertsReviewStageReviewGroups;
	SET @Message = '[qan].[ReviewStageReviewGroups] records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;

	-- [qan].[ReviewGroupReviewers]
	INSERT INTO [qan].[ReviewGroupReviewers]
	(
		  [ReviewStageReviewGroupId]
		, [ReviewerId]
		, [CreatedBy]
		, [UpdatedBy]
	)
	OUTPUT inserted.[Id], inserted.[ReviewStageReviewGroupId], inserted.[ReviewerId] INTO @InsertsReviewGroupReviewers
	SELECT DISTINCT
		  [ReviewStageReviewGroupId]
		, [ReviewerId]
		, @By
		, @By
	FROM @Associations WHERE [ReviewGroupReviewerId] IS NULL;

	UPDATE @Associations SET [ReviewGroupReviewerId] = I.[Id]
	FROM @Associations AS A INNER JOIN @InsertsReviewGroupReviewers AS I ON (I.[ReviewStageReviewGroupId] = A.[ReviewStageReviewGroupId] AND I.[ReviewerId] = A.[ReviewerId])
	WHERE A.[ReviewGroupReviewerId] IS NULL;

	SELECT @Count = COUNT(*) FROM @InsertsReviewGroupReviewers;
	SET @Message = '[qan].[ReviewGroupReviewers] records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;

END
