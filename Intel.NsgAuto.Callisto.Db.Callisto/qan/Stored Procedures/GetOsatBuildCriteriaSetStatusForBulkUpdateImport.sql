CREATE PROCEDURE [qan].[GetOsatBuildCriteriaSetStatusForBulkUpdateImport]
(
		@Groups             [qan].[IOsatQfImportGroups]      READONLY
	, @Criterias          [qan].[IOsatQfImportCriterias]   READONLY
	, @Attributes         [qan].[IOsatQfImportAttributes]  READONLY
	, @OsatId             INT
)
AS
BEGIN
	SET NOCOUNT ON;
	--	Select * into qan.groups_debug from @Groups
	--Select * into qan.criterias_debug from @Criterias
	--Select * into qan.attributes_debug from @Attributes

		SELECT [BuildCombinationId]  =
			(
					SELECT CASE COUNT(*) WHEN 1 THEN MIN([Id]) ELSE NULL END FROM [qan].[OsatBuildCombinations] AS BC WITH (NOLOCK)
				WHERE   ([IsActive]              = 1)
					AND ([DesignId]              = T2.[DesignId])
					--Suresh Added 3/8
					AND([Osatid]				 = @OsatId OR @OsatId          IS NULL)
					--Suresh Added 3/8
					AND ([IntelLevel1PartNumber] = T2.[IntelLevel1PartNumber] OR T2.[IntelLevel1PartNumber]  IS NULL)
					AND ([PartUseTypeId]         = T2.[PartUseTypeId]         OR T2.[PartUseTypeId]          IS NULL)
					AND ([DeviceName]            = T2.[DeviceName2]           OR T2.[DeviceName2]            IS NULL)
					AND ([Mpp]                   = T2.[Mpp]                   OR ([Mpp] IS NULL AND T2.[Mpp] IS NULL))
					AND ([IntelProdName]         = T2.[IntelProdName]         OR T2.[IntelProdName]          IS NULL)
			)
			, [BuildCriteriaName]    = LEFT(T2.[Name], 50)
			, [T2].[DeviceName]
			, [T2].[PartNumberDecode]
			INTO #BuildCombinations
		FROM
		(
				SELECT
				  T1.*
				, [DesignId]                    = D.[Id]
				, [DesignFamilyId]              = D.[DesignFamilyId]
				, [DeviceName2]                 = [qan].[FOsatQfValuesToDeviceName](D.[DesignFamilyId], T1.[PartNumberDecode], T1.[DeviceAv])
				, [IntelProdName]               = [qan].[FOsatQfValuesToIntelProdName](D.[DesignFamilyId], T1.[PartNumberDecode])
			FROM
			(
				SELECT
					  C.*
					, [DesignName]              = [qan].[FOsatQfDesignIdAvAndGroupNameToDesignName](A1.[Value], G.[Name])
					, [DeviceAv]                = [qan].[FOsatQfDeviceAvToDeviceName](A2.[Value])
					, [Mpp]                     = [qan].[FOsatQfDeviceAvToMpp](A2.[Value])
					, [PackageDieCount]         = TRY_CAST(A3.[Value] AS INT)
					, [IntelLevel1PartNumber]   = [qan].[FOsatQfDeviceNameToIntelLevel1PartNumber](C.[DeviceName])
					, [PartUseTypeId]           = [qan].[FOsatQfEsToPartUseTypeId](C.[ES])
				FROM @Criterias AS C
				LEFT OUTER JOIN @Groups AS G ON (G.[Index] = C.[GroupIndex])
				LEFT OUTER JOIN (SELECT [CriteriaIndex], [Value] = CASE WHEN COUNT(*) = 1 THEN MIN([Value]) ELSE NULL END FROM @Attributes WHERE [Name] = 'design_id'            GROUP BY [CriteriaIndex]) AS A1 ON (A1.[CriteriaIndex] = C.[Index])
				LEFT OUTER JOIN (SELECT [CriteriaIndex], [Value] = CASE WHEN COUNT(*) = 1 THEN MIN([Value]) ELSE NULL END FROM @Attributes WHERE [Name] = 'device'               GROUP BY [CriteriaIndex]) AS A2 ON (A2.[CriteriaIndex] = C.[Index])
				LEFT OUTER JOIN (SELECT [CriteriaIndex], [Value] = CASE WHEN COUNT(*) = 1 THEN MIN([Value]) ELSE NULL END FROM @Attributes WHERE [Name] = 'number_of_die_in_pkg' GROUP BY [CriteriaIndex]) AS A3 ON (A3.[CriteriaIndex] = C.[Index])
			) AS T1
			LEFT OUTER JOIN [qan].[Products] AS D WITH (NOLOCK) ON (D.[Name] = T1.[DesignName])
		) AS T2;

		--select * into qan.deleteCriterias from @Criterias
		--select * into qan.deleteGroups from @Groups
		--select * into qan.deleteAttributes from @Attributes
		--select * into qan.deleteBuildCombination from #BuildCombinations

		SELECT 
           [BC].[BuildCombinationId],
           [BC].[BuildCriteriaName],
           [BC].[DeviceName],
           [BC].[PartNumberDecode]
		FROM [qan].[OsatBuildCriteriaSets] AS [OBCS]
		INNER JOIN [#BuildCombinations] AS [BC]
		ON [BC].[BuildCombinationId] = [OBCS].[BuildCombinationId]
		AND [BC].[BuildCombinationId] IS NOT NULL 
		AND [OBCS].[StatusId] IN (1, 3, 5) --Draft, Submitted, InReview
		INNER JOIN [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords] BIR ON BIR.BuildCriteriaSetId = [OBCS].Id

	
END