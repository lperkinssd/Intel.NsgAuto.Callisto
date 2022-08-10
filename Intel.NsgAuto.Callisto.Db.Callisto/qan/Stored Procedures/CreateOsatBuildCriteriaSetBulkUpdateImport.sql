CREATE PROCEDURE [qan].[CreateOsatBuildCriteriaSetBulkUpdateImport]					   
					   
(
	  @Id                 INT                              OUTPUT
	, @Message            VARCHAR(MAX)                     OUTPUT
	, @Succeeded          BIT															 OUTPUT
	, @UserId             VARCHAR(25)
	, @DesignId           INT
	, @OsatId             INT
	, @FileName           VARCHAR(250)
	, @CurrentFile        VARCHAR(250)
	, @FileLengthInBytes  INT
	, @Groups             [qan].[IOsatQfImportGroups]      READONLY
	, @GroupFields        [qan].[IOsatQfImportGroupFields] READONLY
	, @Criterias          [qan].[IOsatQfImportCriterias]   READONLY
	, @Attributes         [qan].[IOsatQfImportAttributes]  READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count                     INT;
	DECLARE @ErrorsExist               BIT                      = 0;
	DECLARE @On                        DATETIME2(7)             = GETUTCDATE();
	DECLARE @PseudoAttributeNames      TABLE
	(
		  [Name]                       VARCHAR(50) PRIMARY KEY
	);

	-- begin standardization
	SET @Id       = NULL;
	SET @Message  = NULL;
	SET @FileName = LTRIM(RTRIM(@FileName));

	INSERT INTO @PseudoAttributeNames VALUES ('design_id'), ('device'), ('number_of_die_in_pkg');
	-- end standardizationright he was comparing STRINGS using doing all

	-- begin create and configure temporary tables
	IF OBJECT_ID('tempdb..#OsatBuildCriteriaSetBulkUpdateImportAttributes')  IS NOT NULL DROP TABLE #OsatBuildCriteriaSetBulkUpdateImportAttributes;
	IF OBJECT_ID('tempdb..#OsatBuildCriteriaSetBulkUpdateImportCriterias')   IS NOT NULL DROP TABLE #OsatBuildCriteriaSetBulkUpdateImportCriterias;
	IF OBJECT_ID('tempdb..#OsatBuildCriteriaSetBulkUpdateImportGroupFields') IS NOT NULL DROP TABLE #OsatBuildCriteriaSetBulkUpdateImportGroupFields;


	SELECT
		  T3.*
		, [BuildCriteriaOrdinal] = ROW_NUMBER() OVER (PARTITION BY T3.[BuildCombinationId] ORDER BY T3.[Index])
	INTO #OsatBuildCriteriaSetBulkUpdateImportCriterias
	FROM
	(
		SELECT
			  T2.*
			, [BuildCombinationId]  =
			(
				-- only populate this field if there is exactly 1 matching build combination; otherwise, set to NULL
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
		) AS T2
	) AS T3;

	--Suresh
	--drop table qan.OsatBuildCriteriaSetBulkUpdateImportCriterias
	--select * into qan.OsatBuildCriteriaSetBulkUpdateImportCriterias from #OsatBuildCriteriaSetBulkUpdateImportCriterias
	-- Suresh
	-- [BuildCriteriaName] cannot be not null; so fix that if neccessary
	UPDATE #OsatBuildCriteriaSetBulkUpdateImportCriterias SET [BuildCriteriaName] = NULLIF(LTRIM(RTRIM([BuildCriteriaName])), '');
	UPDATE #OsatBuildCriteriaSetBulkUpdateImportCriterias SET [BuildCriteriaName] = 'Criteria' WHERE [BuildCriteriaName] IS NULL;

	-- for each [BuildCombinationId] the [BuildCriteriaName] must be unique; so fix that if neccessary
	UPDATE #OsatBuildCriteriaSetBulkUpdateImportCriterias SET
		  [BuildCriteriaName] = [BuildCriteriaName] + ' ' + CAST([BuildCriteriaOrdinal] AS VARCHAR(20))
	FROM #OsatBuildCriteriaSetBulkUpdateImportCriterias
	WHERE [BuildCombinationId] IN
	(
		SELECT [BuildCombinationId] FROM #OsatBuildCriteriaSetBulkUpdateImportCriterias WHERE [BuildCombinationId] IS NOT NULL GROUP BY [BuildCombinationId], [BuildCriteriaName] HAVING COUNT(*) > 1
	)

	/*
	only comparison operations currently supported are:
		in : value contains a comma
		>= : last character of value is '+'
		=  : otherwise (matches nothing above)
	*/
	SELECT
		  T.*
		, [ComparisonOperationKey] = CASE WHEN RIGHT([ValueStandardized], 1) = '+' THEN '>=' WHEN CHARINDEX(',', [ValueStandardized]) > 0 THEN 'in' ELSE '=' END
		, [ValueCondition]         = CASE WHEN RIGHT([ValueStandardized], 1) = '+' THEN LEFT([Value], LEN([ValueStandardized]) - 1) ELSE [ValueStandardized] END
	INTO #OsatBuildCriteriaSetBulkUpdateImportAttributes
	FROM
	(
		SELECT
			  *
			, [NameStandardized]  = NULLIF(LTRIM(RTRIM([Name])), '')
			, [ValueStandardized] = NULLIF(LTRIM(RTRIM([Value])), '')
		FROM @Attributes
	) AS T
	WHERE [NameStandardized] NOT IN (SELECT [Name] FROM @PseudoAttributeNames);

	SELECT
		  F.*
		, [AttributeTypeId] = A.[Id]
	INTO #OsatBuildCriteriaSetBulkUpdateImportGroupFields
	FROM @GroupFields AS F
	LEFT OUTER JOIN [qan].[OsatAttributeTypes] AS A WITH (NOLOCK) ON (A.[Name] = F.[Name] AND F.[IsAttribute] = 1);
	-- end create and configure temporary tables

	-- begin validation

	SELECT @Count = COUNT(*) FROM @Criterias;
	IF (@Count <= 0)
	BEGIN
		SET @Message = 'No criteria data could be determined';
		SET @ErrorsExist = 1;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN

		BEGIN TRANSACTION
		
		BEGIN TRY  

					INSERT INTO [qan].[OsatBuildCriteriaSetBulkUpdateImports]
					(
							[CreatedBy]
						, [CreatedOn]
						, [UpdatedBy]
						, [UpdatedOn]
						, [OriginalFileName]
						, [CurrentFile]
						, [FileLengthInBytes]
						, [DesignId]
					)
					VALUES
					(
							@UserId
						, @On
						, @UserId
						, @On
						, @FileName
						, @CurrentFile
						, @FileLengthInBytes
						, @DesignId
					);

					SELECT @Id = SCOPE_IDENTITY();

					DECLARE @BuildCombinationId               INT;
					DECLARE @BuildCombinationIdsRemaining     TABLE
					(
							[Id] INT NOT NULL
					);
					DECLARE @BuildCriterias                   [qan].[IOsatBuildCriteriasCreate];
					DECLARE @BuildCriteriaSetId               BIGINT;
					DECLARE @BuildCriteriaSetMessage          VARCHAR(500);
					DECLARE @Comment                          VARCHAR(1000)                                = 'Created by bulk import ' + CAST(@Id AS VARCHAR(20));
					DECLARE @Conditions                       [qan].[IOsatBuildCriteriaConditionsCreate];
					DECLARE @Version INT 
					DECLARE @FileVersion INT 

					--Suresh 2/28
					SET @FileVersion = (SELECT (ISNULL(MAX( [OBCSBUIR].[FileVersion]), 0) + 1) FROM [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords] [OBCSBUIR]								 
									WHERE [OBCSBUIR].DesignId=@DesignId AND [OBCSBUIR].OsatId = @OsatId)
					IF @FileVersion iS NULL 
						SET @FileVersion =1
					--Suresh 2/28

					INSERT INTO @BuildCombinationIdsRemaining SELECT DISTINCT [BuildCombinationId] FROM #OsatBuildCriteriaSetBulkUpdateImportCriterias WHERE [BuildCombinationId] IS NOT NULL;
					WHILE (EXISTS (SELECT * FROM @BuildCombinationIdsRemaining))
					BEGIN
						SELECT TOP 1 @BuildCombinationId = [Id] FROM @BuildCombinationIdsRemaining;
						DELETE FROM @BuildCombinationIdsRemaining WHERE [Id] = @BuildCombinationId;

						DELETE FROM @BuildCriterias;
						DELETE FROM @Conditions;

						INSERT INTO @BuildCriterias
						(
								[Index]
							, [Name]
						)
						SELECT
								[BuildCriteriaOrdinal]
							, [BuildCriteriaName]
						FROM #OsatBuildCriteriaSetBulkUpdateImportCriterias WHERE [BuildCombinationId] = @BuildCombinationId;

						INSERT INTO @Conditions
						(
								[Index]
							, [BuildCriteriaIndex]
							, [AttributeTypeName]
							, [ComparisonOperationKey]
							, [Value]
						)
						SELECT
								ROW_NUMBER() OVER (ORDER BY A.[CriteriaIndex] ASC, A.[Index] ASC)
							, C.[BuildCriteriaOrdinal]
							, A.[Name]
							, A.[ComparisonOperationKey]
							, A.[ValueCondition]
						FROM #OsatBuildCriteriaSetBulkUpdateImportAttributes AS A
						INNER JOIN #OsatBuildCriteriaSetBulkUpdateImportCriterias AS C ON (C.[Index] = A.[CriteriaIndex])
						WHERE A.[ValueCondition] IS NOT NULL AND C.[BuildCombinationId] = @BuildCombinationId;

						EXEC [qan].[CreateOsatBuildCriteriaSet] @BuildCriteriaSetId OUTPUT, @BuildCriteriaSetMessage OUTPUT, @UserId, @BuildCombinationId, @BuildCriterias, @Conditions, @Comment;

						IF (@BuildCriteriaSetId IS NOT NULL)
						BEGIN


							-- cancel any existing versions in Draft, Submitted, or In Review status matching the build combination id
							UPDATE  S SET
									[StatusId] = 2 -- Canceled
								, [UpdatedBy] = @UserId
								, [UpdatedOn] = @On
							FROm [qan].[OsatBuildCriteriaSets] S
							INNER JOIN [qan].[OsatBuildCombinations]       AS C   WITH (NOLOCK) ON (C.[Id] = S.[BuildCombinationId])	
						--	INNER JOIN  [qan].[OsatBuildCombinationOsats]   AS CO  WITH (NOLOCK) ON (CO.[BuildCombinationId] = C.[Id])							 
							WHERE [StatusId] IN (1, 3, 5) --Draft, Submitted, or In Review
								AND S.[BuildCombinationId] = @BuildCombinationId
								AND S.[Id] <> @BuildCriteriaSetId
								AND C.Osatid=@OsatId;

							--Suresh @2/28
							IF @Version IS NULL
								SET @Version = (SELECT [Version] FROM [qan].[OsatBuildCriteriaSets] S
													INNER JOIN [qan].[OsatBuildCombinations]       AS C   WITH (NOLOCK) ON (C.[Id] = S.[BuildCombinationId])	
												--	INNER JOIN  [qan].[OsatBuildCombinationOsats]   AS CO  WITH (NOLOCK) ON (CO.[BuildCombinationId] = C.[Id])
													WHERE S.Id=@BuildCriteriaSetId and C.Osatid=@OsatId)
							--Suresh @2/28

							INSERT INTO [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords]
							 ([ImportId]
							 ,[BuildCriteriaSetId]
							 ,[BuildCombinationId]
							 ,[Version]
							 ,[FileVersion]
							 ,OsatId
							 ,[DesignId]
							 ,[DesignFamilyId]
							 ,[DeviceName]
							 ,[PartNumberDecode]
							 ,[IntelLevel1PartNumber]
							 ,[IntelProdName]
							 ,[Attribute]
							 ,[NewValue]
							 ,[OldValue]
							 ,[BuildCriteriaOrdinal])

							SELECT
									@Id
								, @BuildCriteriaSetId
								, @BuildCombinationId
								, @Version
								, @FileVersion
								, @OsatId
								, @DesignId
								, C2.DesignFamilyId
								, C2.DeviceName
								, C2.PartNumberDecode
								, C2.IntelLevel1PartNumber
								, C2.IntelProdName
								, A.Name
								, A.Value
								, NULL
								, C2.[BuildCriteriaOrdinal]
							FROM [qan].[OsatBuildCriterias]                AS C1 WITH (NOLOCK)
							LEFT OUTER JOIN #OsatBuildCriteriaSetBulkUpdateImportCriterias AS C2 ON (C2.[BuildCriteriaOrdinal] = C1.[Ordinal])
							LEFT OUTER JOIN #OsatBuildCriteriaSetBulkUpdateImportAttributes AS A ON (C2.[Index] = A.[CriteriaIndex])
							LEFT OUTER JOIN @Groups                        AS G  ON (G.[Index]  = C2.[GroupIndex])
							WHERE C1.[BuildCriteriaSetId] = @BuildCriteriaSetId AND C2.[BuildCombinationId] = @BuildCombinationId;
						END;
						ELSE
						BEGIN
							RAISERROR (@BuildCriteriaSetMessage, -- Message text.  
									 16, -- Severity.  
									 1 -- State.  
									 );  
						END;
					END;


					UPDATE [IR] 
					SET
											[OldValue] = [BCC].[Value]
					FROM
											[qan].[OsatBuildCriteriaSetBulkUpdateImportRecords] [IR]
					INNER JOIN  [qan].[OsatBuildCriteriaSets]                       [BCS]
											ON [IR].[BuildCombinationId] = [BCS].[BuildCombinationId]
													AND [IR].[ImportId]=@Id
					INNER JOIN (
											SELECT MAX([Version]) [Version],[BuildCombinationId] 
											FROM [qan].[OsatBuildCriteriaSets]
											WHERE [IsPOR]=1
											GROUP BY [BuildCombinationId]
					) LV
											ON [LV].[BuildCombinationId]=[BCS].[BuildCombinationId]
											AND [LV].[Version]=[BCS].[Version]
					INNER JOIN  [qan].[OsatBuildCriterias]                          [BC]
											ON [BC].[BuildCriteriaSetId] = [BCS].[Id]
					INNER JOIN  [qan].[OsatBuildCriteriaConditions]                 [BCC]
											ON [BCC].[BuildCriteriaId]   = [BC].[Id]
					INNER JOIN  [qan].[OsatAttributeTypes]                          [AT]
											ON [AT].[Id]                 = [BCC].[AttributeTypeId]
													AND [AT].[Name]           = [IR].[Attribute];

					SELECT 
							[Id]
							,[ImportId]
							,[BuildCriteriaSetId]
							,[BuildCombinationId]
							,[Version]
							,[DesignId]
							,[DesignFamilyId]
							,[DeviceName]
							,[PartNumberDecode]
							,[IntelLevel1PartNumber]
							,[IntelProdName]
							,[Attribute]
							,[NewValue]
							,[OldValue]
					FROM [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords]
					WHERE ImportId=@Id

		END TRY  
		BEGIN CATCH  
			
				SET @Succeeded = 0;
				SET @Message = CONCAT(@Message, ' - ', ERROR_PROCEDURE(), ' - ', ERROR_LINE(), ' - ', ERROR_MESSAGE())
  
				IF @@TRANCOUNT > 0  
						ROLLBACK TRANSACTION;  
		END CATCH;  
			
		IF @@TRANCOUNT > 0  
		BEGIN
				COMMIT TRANSACTION;  
				SET @Succeeded = 1;		    
		END


	END;

	DROP TABLE #OsatBuildCriteriaSetBulkUpdateImportAttributes;
	DROP TABLE #OsatBuildCriteriaSetBulkUpdateImportCriterias;
	DROP TABLE #OsatBuildCriteriaSetBulkUpdateImportGroupFields;


END
