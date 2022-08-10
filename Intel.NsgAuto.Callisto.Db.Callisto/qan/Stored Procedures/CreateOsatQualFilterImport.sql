-- =================================================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-24 13:38:16.220
-- Description  : Creates a new auto checker qual filter import. After execution, if the output parameter @Id is null, then the import was not created
--                and @Message contains the reason.
-- Example      : DECLARE @Id          INT;
--                DECLARE @Message     VARCHAR(500);
--                DECLARE @Groups      [qan].[IOsatQfImportGroups];
--                DECLARE @GroupFields [qan].[IOsatQfImportGroupFields];
--                DECLARE @Criterias   [qan].[IOsatQfImportCriterias];
--                DECLARE @Attributes  [qan].[IOsatQfImportAttributes];
--                EXEC [qan].[CreateOsatQualFilterImport] @Id OUTPUT, @Message OUTPUT, 'bricschx', 'test.xlsx', 0, @Groups, @GroupFields, @Criterias, @Attributes;
--                PRINT 'Id = ' + ISNULL(CAST(@Id AS VARCHAR(20)), 'null') + '; Message = ' + ISNULL(@Message, 'null');
--                -- should print: Id = null; Message = No criteria data could be determined
-- =================================================================================================================================================================
CREATE PROCEDURE [qan].[CreateOsatQualFilterImport]
(
	  @Id                 INT                              OUTPUT
	, @Message            VARCHAR(500)                     OUTPUT
	, @UserId             VARCHAR(25)
	, @FileName           VARCHAR(250)
	, @FileLengthInBytes  INT
	, @Groups             [qan].[IOsatQfImportGroups]      READONLY
	, @GroupFields        [qan].[IOsatQfImportGroupFields] READONLY
	, @Criterias          [qan].[IOsatQfImportCriterias]   READONLY
	, @Attributes         [qan].[IOsatQfImportAttributes]  READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionDescription         VARCHAR (1000)           = 'Create';
	DECLARE @Count                     INT;
	DECLARE @DesignId                  INT;
	DECLARE @DesignIdMin               INT;
	DECLARE @DesignIdMax               INT;
	DECLARE @DesignName                VARCHAR (10);
	DECLARE @ErrorsExist               BIT                      = 0;
	Declare @OsatId             INT = 2

	DECLARE @Messages                  TABLE
	(
		  [MessageType]                VARCHAR (20)   NOT NULL
		, [Message]                    VARCHAR (500)  NOT NULL
		, [GroupIndex]                 INT                NULL
		, [GroupSourceIndex]           INT                NULL
		, [CriteriaIndex]              INT                NULL
		, [CriteriaSourceIndex]        INT                NULL
		, [GroupFieldIndex]            INT                NULL
		, [GroupFieldSourceIndex]      INT                NULL
		, [GroupFieldName]             VARCHAR (100)      NULL
	);
	DECLARE @On                        DATETIME2(7)             = GETUTCDATE();
	DECLARE @PseudoAttributeNames      TABLE
	(
		  [Name]                       VARCHAR(50) PRIMARY KEY
	);
	DECLARE @Succeeded                 BIT                      = 0;

	-- begin standardization
	SET @Id       = NULL;
	SET @Message  = NULL;
	SET @FileName = LTRIM(RTRIM(@FileName));

	IF  @FileName like '%ATC%'  
		SET @OsatId =1

	INSERT INTO @PseudoAttributeNames VALUES ('design_id'), ('device'), ('number_of_die_in_pkg');
	-- end standardization

	-- begin create and configure temporary tables
	IF OBJECT_ID('tempdb..#OsatQualFilterImportAttributes')  IS NOT NULL DROP TABLE #OsatQualFilterImportAttributes;
	IF OBJECT_ID('tempdb..#OsatQualFilterImportCriterias')   IS NOT NULL DROP TABLE #OsatQualFilterImportCriterias;
	IF OBJECT_ID('tempdb..#OsatQualFilterImportGroupFields') IS NOT NULL DROP TABLE #OsatQualFilterImportGroupFields;

	-- [DesignFamilyId]: 1 = NAND; 2 = Optane
	-- [PartUseTypeId] : 1 = Production; 2 = Engineering Sample
	SELECT
		  T3.*
		, [BuildCriteriaOrdinal] = ROW_NUMBER() OVER (PARTITION BY T3.[BuildCombinationId] ORDER BY T3.[Index])
	INTO #OsatQualFilterImportCriterias
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
				-- @Criterias.[DeviceName] is not the correct value to match against [qan].[OsatBuildCombinations].[DeviceName]; [DeviceName2] below contains logic to match against that field
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

	-- [BuildCriteriaName] cannot be not null; so fix that if neccessary
	UPDATE #OsatQualFilterImportCriterias SET [BuildCriteriaName] = NULLIF(LTRIM(RTRIM([BuildCriteriaName])), '');
	UPDATE #OsatQualFilterImportCriterias SET [BuildCriteriaName] = 'Criteria' WHERE [BuildCriteriaName] IS NULL;

	-- for each [BuildCombinationId] the [BuildCriteriaName] must be unique; so fix that if neccessary
	UPDATE #OsatQualFilterImportCriterias SET
		  [BuildCriteriaName] = [BuildCriteriaName] + ' ' + CAST([BuildCriteriaOrdinal] AS VARCHAR(20))
	FROM #OsatQualFilterImportCriterias
	WHERE [BuildCombinationId] IN
	(
		SELECT [BuildCombinationId] FROM #OsatQualFilterImportCriterias WHERE [BuildCombinationId] IS NOT NULL GROUP BY [BuildCombinationId], [BuildCriteriaName] HAVING COUNT(*) > 1
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
	INTO #OsatQualFilterImportAttributes
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
	INTO #OsatQualFilterImportGroupFields
	FROM @GroupFields AS F
	LEFT OUTER JOIN [qan].[OsatAttributeTypes] AS A WITH (NOLOCK) ON (A.[Name] = F.[Name] AND F.[IsAttribute] = 1);
	-- end create and configure temporary tables

	-- begin validation

	-- logic to determine the design id associated with the entire file
	SELECT @DesignIdMin = MIN([DesignId]), @DesignIdMax = MAX([DesignId]) FROM #OsatQualFilterImportCriterias WITH (NOLOCK);
	IF (@DesignIdMin IS NOT NULL AND @DesignIdMax IS NOT NULL AND @DesignIdMin = @DesignIdMax)
	BEGIN
		SET @DesignId = @DesignIdMin;
	END;
	ELSE
	BEGIN
		IF (@DesignIdMin IS NOT NULL AND @DesignIdMax IS NOT NULL AND @DesignIdMin <> @DesignIdMax)
		BEGIN
			SET @Message = 'Criteria for multiple designs are not supported: ' + @DesignIdMin + ' vs ' + @DesignIdMax;
			SET @ErrorsExist = 1;
		END;
		ELSE
		BEGIN
			-- file design id could not be determined based on the criteria, so try to determine it using the filename
			SET @DesignName = SUBSTRING(@FileName, 1, 4);
			SELECT @DesignId = MIN([Id]) FROM [qan].[Products] WITH (NOLOCK) WHERE [Name] = @DesignName;
			IF (@DesignId IS NULL)
			BEGIN
				SET @Message = 'Design Id could not be determined';
				SET @ErrorsExist = 1;
			END;
		END;
	END;

	INSERT INTO @Messages
	(
		  [MessageType]
		, [Message]
		, [GroupIndex]
		, [GroupSourceIndex]
		, [CriteriaIndex]
		, [CriteriaSourceIndex]
	)
	SELECT
		  'Error'
		, 'Associated part could not be determined'
		, C.[GroupIndex]
		, G.[SourceIndex]
		, C.[Index]
		, C.[SourceIndex]
	FROM #OsatQualFilterImportCriterias AS C
	LEFT OUTER JOIN @Groups             AS G ON (G.[Index] = C.[GroupIndex])
	WHERE C.[BuildCombinationId] IS NULL;

	INSERT INTO @Messages
	(
		  [MessageType]
		, [Message]
		, [GroupIndex]
		, [GroupSourceIndex]
		, [GroupFieldIndex]
		, [GroupFieldSourceIndex]
		, [GroupFieldName]
	)
	SELECT
		  'Warning'
		, 'Associated attribute could not be determined'
		, F.[GroupIndex]
		, G.[SourceIndex]
		, F.[Index]
		, F.[SourceIndex]
		, F.[Name]
	FROM #OsatQualFilterImportGroupFields AS F
	LEFT OUTER JOIN @Groups               AS G  ON (G.[Index] = F.[GroupIndex])
	WHERE F.[AttributeTypeId] IS NULL AND F.[IsAttribute] = 1 AND F.[Name] NOT IN (SELECT [Name] FROM @PseudoAttributeNames);

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

			INSERT INTO [qan].[OsatQualFilterImports]
			(
				  [CreatedBy]
				, [CreatedOn]
				, [UpdatedBy]
				, [UpdatedOn]
				, [FileName]
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
			DECLARE @Comment                          VARCHAR(1000)                                = 'Created by qual filter import ' + CAST(@Id AS VARCHAR(20));
			DECLARE @Conditions                       [qan].[IOsatBuildCriteriaConditionsCreate];

			INSERT INTO @BuildCombinationIdsRemaining SELECT DISTINCT [BuildCombinationId] FROM #OsatQualFilterImportCriterias WHERE [BuildCombinationId] IS NOT NULL;
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
				FROM #OsatQualFilterImportCriterias WHERE [BuildCombinationId] = @BuildCombinationId;

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
				FROM #OsatQualFilterImportAttributes AS A
				INNER JOIN #OsatQualFilterImportCriterias AS C ON (C.[Index] = A.[CriteriaIndex])
				WHERE A.[ValueCondition] IS NOT NULL AND C.[BuildCombinationId] = @BuildCombinationId;

				EXEC [qan].[CreateOsatBuildCriteriaSet] @BuildCriteriaSetId OUTPUT, @BuildCriteriaSetMessage OUTPUT, @UserId, @BuildCombinationId, @BuildCriterias, @Conditions, @Comment;

				IF (@BuildCriteriaSetId IS NOT NULL)
				BEGIN
					INSERT INTO [qan].[OsatQualFilterImportBuildCriterias]
					(
						  [ImportId]
						, [BuildCriteriaSetId]
						, [BuildCriteriaId]
						, [GroupIndex]
						, [GroupSourceIndex]
						, [CriteriaIndex]
						, [CriteriaSourceIndex]
					)
					SELECT
						  @Id
						, C1.[BuildCriteriaSetId]
						, C1.[Id]
						, C2.[GroupIndex]
						, G.[SourceIndex]
						, C2.[Index]
						, C2.[SourceIndex]
					FROM [qan].[OsatBuildCriterias]                AS C1 WITH (NOLOCK)
					LEFT OUTER JOIN #OsatQualFilterImportCriterias AS C2 ON (C2.[BuildCriteriaOrdinal] = C1.[Ordinal])
					LEFT OUTER JOIN @Groups                        AS G  ON (G.[Index]                 = C2.[GroupIndex])
					WHERE C1.[BuildCriteriaSetId] = @BuildCriteriaSetId AND C2.[BuildCombinationId] = @BuildCombinationId;
				END;
				ELSE
				BEGIN
					INSERT INTO @Messages
					(
						  [MessageType]
						, [Message]
						, [GroupIndex]
						, [GroupSourceIndex]
						, [CriteriaIndex]
						, [CriteriaSourceIndex]
					)
					SELECT
						  'Error'
						, 'Could not be created' + ISNULL('; ' + @BuildCriteriaSetMessage, '')
						, C.[GroupIndex]
						, G.[SourceIndex]
						, C.[Index]
						, C.[SourceIndex]
					FROM #OsatQualFilterImportCriterias AS C
					LEFT OUTER JOIN @Groups             AS G ON (G.[Index] = C.[GroupIndex])
					WHERE [BuildCombinationId] = @BuildCombinationId;
				END;
			END;

			SELECT @Count = COUNT(*) FROM [qan].[OsatQualFilterImportBuildCriterias] WITH (NOLOCK) WHERE [ImportId] = @Id;
			SET @ActionDescription = @ActionDescription + '; Build Criterias: ' + CAST(@Count AS VARCHAR(20));

			INSERT INTO [qan].[OsatQualFilterImportMessages]
			(
				  [ImportId]
				, [MessageType]
				, [Message]
				, [GroupIndex]
				, [GroupSourceIndex]
				, [CriteriaIndex]
				, [CriteriaSourceIndex]
				, [GroupFieldIndex]
				, [GroupFieldSourceIndex]
				, [GroupFieldName]
			)
			SELECT
				  @Id
				, [MessageType]
				, [Message]
				, [GroupIndex]
				, [GroupSourceIndex]
				, [CriteriaIndex]
				, [CriteriaSourceIndex]
				, [GroupFieldIndex]
				, [GroupFieldSourceIndex]
				, [GroupFieldName]
			FROM @Messages;

			SET @ActionDescription = @ActionDescription + '; Messages: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

			SELECT @Count = COUNT(*) FROM @Messages WHERE [MessageType] = 'Error';
			DECLARE @MessageErrorsExist BIT = CASE WHEN (@Count > 0) THEN 1 ELSE 0 END;
			UPDATE [qan].[OsatQualFilterImports] SET [MessageErrorsExist] = @MessageErrorsExist WHERE [Id] = @Id;

		COMMIT;

		SET @Succeeded = 1;
	END;

	DROP TABLE #OsatQualFilterImportAttributes;
	DROP TABLE #OsatQualFilterImportCriterias;
	DROP TABLE #OsatQualFilterImportGroupFields;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', 'Create', 'OsatQualFilterImport', @Id, NULL, @Succeeded, @Message;

END
