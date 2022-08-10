
-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-02-25 15:22:57.960
-- Description  : Merges data into the [qan].[OsatBuildCombinations] table
-- Example      : EXEC [qan].[MergeOsatBuildCombinations];
-- =======================================================================
CREATE PROCEDURE [qan].[MergeOsatBuildCombinations]
(
	  @CountInserted INT = NULL OUTPUT
	, @CountUpdated  INT = NULL OUTPUT
	, @CountDeleted  INT = NULL OUTPUT
	, @By VARCHAR(25)    = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RecordsPOR TABLE
	(
		  [BuildCombinationId]     INT                    NULL
		, [OsatId]                 INT                NOT NULL
		, [DesignId]               INT                NOT NULL
		, [PartUseTypeId]          INT                NOT NULL
		, [MaterialMasterField]    VARCHAR  (10)      NOT NULL
		, [IntelLevel1PartNumber]  VARCHAR  (25)      NOT NULL
		, [IntelProdName]          VARCHAR  (100)     NOT NULL
		, [IntelMaterialPn]        VARCHAR  (25)      NOT NULL
		, [AssyUpi]                VARCHAR  (25)      NOT NULL
		, [DeviceName]             VARCHAR  (25)      NOT NULL
		, [Mpp]                    VARCHAR  (10)          NULL
		, [PackageDieTypeId]       INT                NOT NULL
		, INDEX [IX_BuildCombinationId] ([BuildCombinationId])
		, INDEX [IX_OsatId] ([OsatId])
	);

	DECLARE @MergeResults TABLE
	(
		  [Action]                 VARCHAR  (25)      NOT NULL
		, [Id]                     INT                NOT NULL
		, [DesignId]               INT
		, [OsatId]               INT
		, [MaterialMasterField]    VARCHAR  (10)
		, [IntelLevel1PartNumber]  VARCHAR  (25)
		, [IntelProdName]          VARCHAR  (100)
		, [IntelMaterialPn]        VARCHAR  (25)
		, [AssyUpi]                VARCHAR  (25)
		, [DeviceName]             VARCHAR  (25)
	);

	IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	INSERT INTO @RecordsPOR
	(
		  [BuildCombinationId]
		, [OsatId]
		, [DesignId]
		, [PartUseTypeId]
		, [MaterialMasterField]
		, [IntelLevel1PartNumber]
		, [IntelProdName]
		, [IntelMaterialPn]
		, [AssyUpi]
		, [DeviceName]
		, [Mpp]
		, [PackageDieTypeId]
	)
	SELECT DISTINCT
		  B.[Id]                       -- [BuildCombinationId]
		, Z.[OsatId]                   -- [OsatId]
		, Z.[DesignId]                 -- [DesignId]
		, Z.[PartUseTypeId]            -- [PartUseTypeId]
		, Z.[MaterialMasterField]      -- [MaterialMasterField]
		, Z.[IntelLevel1PartNumber]    -- [IntelLevel1PartNumber]
		, Z.[IntelProdName]            -- [IntelProdName]
		, Z.[IntelMaterialPn]          -- [IntelMaterialPn]
		, Z.[AssyUpi]                  -- [AssyUpi]
		, Z.[DeviceName]               -- [DeviceName]
		, Z.[Mpp]                      -- [Mpp]
		, DT.[Id]                      -- [PackageDieTypeId]
	FROM
	(
		SELECT DISTINCT
			  R.*
			, [DesignId]           = D.[Id]
			, [OsatId]             = PC.[OsatId]
			, [PartUseTypeId]      = CASE LEFT(R.[SpecNumberField], 1) WHEN 'S' THEN 1 WHEN 'Q' THEN 2 ELSE NULL END  -- 1 = Production, 2 = Engineering Sample
			, [PackageDieTypeName] = [qan].[FParseOsatPackageDieTypeFromIntelProdName](R.[IntelProdName])
		FROM [qan].[OsatPasVersionRecords]       AS R  WITH (NOLOCK)
		INNER JOIN [qan].[OsatPasVersions]       AS V  WITH (NOLOCK) ON (V.[Id] = R.[VersionId])
		INNER JOIN [qan].[OsatPasCombinations]   AS PC WITH (NOLOCK) ON (PC.[Id] = V.[CombinationId])
		INNER JOIN [qan].[Products]              AS D  WITH (NOLOCK) ON (D.[Name] = R.[Did])
		WHERE V.[IsPOR] = 1
		  AND R.[Project] = 'Test' -- get rid of [Project] = 'Reclaim' records as they aren't used for osat build criterias
		  AND LEFT(R.[SpecNumberField], 1) IN ('S', 'Q')
	) AS Z
	LEFT OUTER JOIN [qan].[OsatPackageDieTypes] AS DT WITH (NOLOCK) ON (DT.[Name] = Z.[PackageDieTypeName])
	LEFT OUTER JOIN [qan].[OsatBuildCombinations] AS B WITH (NOLOCK) ON
	(		    B.[Osatid]				= Z.[OsatId] 
		  AND B.[DesignId]              = Z.[DesignId]
		  AND B.[MaterialMasterField]   = Z.[MaterialMasterField]
		  AND B.[IntelLevel1PartNumber] = Z.[IntelLevel1PartNumber]
		  AND B.[IntelProdName]         = Z.[IntelProdName]
		  AND B.[IntelMaterialPn]       = Z.[IntelMaterialPn]
		  AND B.[AssyUpi]               = Z.[AssyUpi]
		  AND B.[DeviceName]            = Z.[DeviceName]
	);

	-- #1 [qan].[OsatBuildCombinations]
	MERGE [qan].[OsatBuildCombinations] AS T -- target
	USING
	(
		SELECT DISTINCT
			  [BuildCombinationId]
			,[OsatId] 
			, [DesignId]
			, [PartUseTypeId]
			, [MaterialMasterField]
			, [IntelLevel1PartNumber]
			, [IntelProdName]
			, [IntelMaterialPn]
			, [AssyUpi]
			, [DeviceName]
			, [Mpp]
			, [PackageDieTypeId]
		FROM @RecordsPOR
	) AS S -- source
	ON (T.[Id] = S.[BuildCombinationId] and T.[Osatid] = S.[OsatId])
	WHEN MATCHED AND
		(
			   T.[PartUseTypeId] <> S.[PartUseTypeId]
			OR T.[PackageDieTypeId] <> S.[PackageDieTypeId]
			OR T.[IsActive] = 0
			OR T.[Mpp] <> S.[Mpp]
			OR (T.[Mpp] IS NULL AND S.[Mpp] IS NOT NULL)
			OR (T.[Mpp] IS NOT NULL AND S.[Mpp] IS NULL)
		)
		THEN UPDATE SET
			  [PartUseTypeId] = S.[PartUseTypeId]
			, [Mpp] = S.[Mpp]
			, [IsActive] = 1
			, [UpdatedBy] = @By
			, [UpdatedOn] = GETUTCDATE()
	WHEN NOT MATCHED BY TARGET THEN INSERT
		(     [Osatid]
			, [DesignId]
			, [PartUseTypeId]
			, [MaterialMasterField]
			, [IntelLevel1PartNumber]
			, [IntelProdName]
			, [IntelMaterialPn]
			, [AssyUpi]
			, [DeviceName]
			, [Mpp]
			, [PackageDieTypeId]
			, [CreatedBy]
			, [UpdatedBy]
		)
		VALUES
		(
			  S.[OsatId]
			, S.[DesignId]               -- [DesignId]
			, S.[PartUseTypeId]          -- [PartUseTypeId]
			, S.[MaterialMasterField]    -- [MaterialMasterField]
			, S.[IntelLevel1PartNumber]  -- [IntelLevel1PartNumber]
			, S.[IntelProdName]          -- [IntelProdName]
			, S.[IntelMaterialPn]        -- [IntelMaterialPn]
			, S.[AssyUpi]                -- [AssyUpi]
			, S.[DeviceName]             -- [DeviceName]
			, S.[Mpp]                    -- [Mpp]
			, S.[PackageDieTypeId]       -- [PackageDieTypeId]
			, @By                        -- [CreatedBy]
			, @By                        -- [UpdatedBy]
		)
	WHEN NOT MATCHED BY SOURCE THEN UPDATE SET [IsActive] = 0, [UpdatedBy] = @By, [UpdatedOn] = GETUTCDATE()
	OUTPUT
		  $action                                                              -- [Action]
		, CASE $action WHEN 'DELETE' THEN deleted.[Id] ELSE inserted.[Id] END  -- [Id]
		, inserted.[Osatid]                                                    -- [OsatId]
		, inserted.[DesignId]                                                  -- [DesignId]
		, inserted.[MaterialMasterField]                                       -- [MaterialMasterField]
		, inserted.[IntelLevel1PartNumber]                                     -- [IntelLevel1PartNumber]
		, inserted.[IntelProdName]                                             -- [IntelProdName]
		, inserted.[IntelMaterialPn]                                           -- [IntelMaterialPn]
		, inserted.[AssyUpi]                                                   -- [AssyUpi]
		, inserted.[DeviceName]                                                -- [DeviceName]
	INTO @MergeResults;

	SELECT @CountInserted = COUNT(*) FROM @MergeResults WHERE [Action] = 'INSERT';
	SELECT @CountUpdated  = COUNT(*) FROM @MergeResults WHERE [Action] = 'UPDATE';
	SELECT @CountDeleted  = COUNT(*) FROM @MergeResults WHERE [Action] = 'DELETE';

	-- update @RecordsPOR setting the [BuildCombinationId] field from merge #1
	UPDATE R
	SET
		R.[BuildCombinationId] = M.[Id]
	FROM @RecordsPOR AS R
	INNER JOIN
	(
		SELECT
			  [Id]
			, [DesignId]
			, [OsatId]
			, [MaterialMasterField]
			, [IntelLevel1PartNumber]
			, [IntelProdName]
			, [IntelMaterialPn]
			, [AssyUpi]
			, [DeviceName]
		FROM @MergeResults WHERE [Action] IN ('INSERT', 'UPDATE')
	) AS M ON
	(		  M.[OsatId]                = R.[OsatId]
		  AND M.[DesignId]              = R.[DesignId]
		  AND M.[MaterialMasterField]   = R.[MaterialMasterField]
		  AND M.[IntelLevel1PartNumber] = R.[IntelLevel1PartNumber]
		  AND M.[IntelProdName]         = R.[IntelProdName]
		  AND M.[IntelMaterialPn]       = R.[IntelMaterialPn]
		  AND M.[AssyUpi]               = R.[AssyUpi]
		  AND M.[DeviceName]            = R.[DeviceName]
	);

	-- #2 [qan].[OsatBuildCombinationOsats]
	MERGE [qan].[OsatBuildCombinationOsats] AS T  -- target
	USING
	(
		SELECT DISTINCT
			  [BuildCombinationId]
			, [OsatId]
		FROM @RecordsPOR
		WHERE [BuildCombinationId] IS NOT NULL AND [OsatId] IS NOT NULL
	) AS S -- source
	ON (T.[BuildCombinationId] = S.[BuildCombinationId] AND T.[OsatId] = S.[OsatId])
	WHEN NOT MATCHED BY TARGET THEN INSERT
		(
			  [BuildCombinationId]
			, [OsatId]
			, [CreatedBy]
			, [UpdatedBy]
		)
		VALUES
		(
			  S.[BuildCombinationId]     -- [BuildCombinationId]
			, S.[OsatId]                 -- [OsatId]
			, @By                        -- [CreatedBy]
			, @By                        -- [UpdatedBy]
		)
	WHEN NOT MATCHED BY SOURCE THEN DELETE;

END
