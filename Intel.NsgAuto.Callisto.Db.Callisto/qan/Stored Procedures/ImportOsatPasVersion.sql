-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-28 17:37:53.647
-- Description  : Performs an OSAT PAS version import
-- Example      : DECLARE @Id INT;
--                DECLARE @Records [qan].[IOsatPasVersionRecordsImport];
--                INSERT INTO @Records ([RecordNumber], [Project], [IntelProdName], [IntelLevel1PartNumber], [SpecNumberField], [MaterialMasterField], [AssyUpi], [DeviceName], [IntelMaterialPn])
--                VALUES ( 1, 'Test', 'B16A 8DP 256GB BGA 132 8CE', 'PF29F02T2AOCTH2', 'Q TFA', '953367', '2000-128-804', 'B16A-82FF-C528', 'J40342-001')
--                     , ( 2, '', 'B16A 8DP 256GB BGA 132 8CE', 'PF29F02T2AOCTH2', 'Q TFA', '953367', '2000-128-804', 'B16A-82FF-C528', 'J40342-001')
--                     , ( 3, 'Test', '', 'PF29F02T2AOCTH2', 'Q TFA', '953367', '2000-128-804', 'B16A-82FF-C528', 'J40342-001')
--                     , ( 4, 'Test', 'B16A 8DP 256GB BGA 132 8CE', '', 'Q TFA', '953367', '2000-128-804', 'B16A-82FF-C528', 'J40342-001')
--                     , ( 5, 'Test', 'B16A 8DP 256GB BGA 132 8CE', 'PF29F02T2AOCTH2', '', '953367', '2000-128-804', 'B16A-82FF-C528', 'J40342-001')
--                     , ( 6, 'Test', 'B16A 8DP 256GB BGA 132 8CE', 'PF29F02T2AOCTH2', 'Q TFA', '', '2000-128-804', 'B16A-82FF-C528', 'J40342-001')
--                     , ( 7, 'Test', 'B16A 8DP 256GB BGA 132 8CE', 'PF29F02T2AOCTH2', 'Q TFA', '953367', '', 'B16A-82FF-C528', 'J40342-001')
--                     , ( 8, 'Test', 'B16A 8DP 256GB BGA 132 8CE', 'PF29F02T2AOCTH2', 'Q TFA', '953367', '2000-128-804', '', 'J40342-001')
--                     , ( 9, 'Test', 'B16A 8DP 256GB BGA 132 8CE', 'PF29F02T2AOCTH2', 'Q TFA', '953367', '2000-128-804', 'B16A-82FF-C528', '')
--                     , (10, 'Test', 'B16A 8DP 256GB BGA 132 8CE', 'PF29F02T2AOCTH2', 'Q TFA', '953367', '2000-128-804', 'B16A-82FF-C528', 'J40342-001');
--                EXEC [qan].[ImportOsatPasVersion] @Id OUTPUT, NULL, 'bricschx', 1, 1, 'test.xlsx', 0, @Records;
--                PRINT @Id;
--                -- only the first record should actually be imported, the rest should generate errors
-- ===============================================================================================================
CREATE PROCEDURE [qan].[ImportOsatPasVersion]
(
	  @Id                 INT OUTPUT
	, @Message            VARCHAR(500) OUTPUT
	, @UserId             VARCHAR(25)
	, @OsatId             INT
	, @DesignFamilyId     INT
	, @OriginalFileName   VARCHAR(250)
	, @FileLengthInBytes  INT
	, @Records  [qan].[IOsatPasVersionRecordsImport] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ActionType           VARCHAR(100) = 'Import';
	DECLARE @ActionDescription    VARCHAR (1000) = @ActionType + '; OsatId = ' + ISNULL(CAST(@OsatId AS VARCHAR(20)), '') + '; DesignFamilyId = ' + ISNULL(CAST(@DesignFamilyId AS VARCHAR(20)), '') + '; OriginalFileName = ''' + @OriginalFileName  + '''; FileLengthInBytes = ' + ISNULL(CAST(@FileLengthInBytes AS VARCHAR(20)), '');
	DECLARE @CombinationId        INT;
	DECLARE @Count                INT;
	DECLARE @ErrorsExist          BIT = 0;
	DECLARE @Messages             [qan].[IImportMessages];
	DECLARE @OsatIdValidated      INT;
	DECLARE @DesignIdValidated    INT;
	DECLARE @RecordsStandardized  [qan].[IOsatPasVersionRecordsImport];
	DECLARE @Succeeded            BIT = 0;
	DECLARE @Version              INT;

	-- begin: standardization
	SET @Id = NULL;
	SET @Message = NULL;
	IF (@OriginalFileName = '') SET @OriginalFileName = NULL;

	-- all pertinent fields trimmed and converted to null if empty string
	-- note: this simplifies subsequent code as all that is required is a null check for empty fields
	INSERT INTO @RecordsStandardized
	SELECT
		  [RecordNumber]
		, NULLIF(RTRIM(LTRIM([ProductGroup])), '')
		, NULLIF(RTRIM(LTRIM([Project])), '')
		, NULLIF(RTRIM(LTRIM([IntelProdName])), '')
		, NULLIF(RTRIM(LTRIM([IntelLevel1PartNumber])), '')
		, NULLIF(RTRIM(LTRIM([Line1TopSideMarking])), '')
		, NULLIF(RTRIM(LTRIM([CopyrightYear])), '')
		, NULLIF(RTRIM(LTRIM([SpecNumberField])), '')
		, NULLIF(RTRIM(LTRIM([MaterialMasterField])), '')
		, NULLIF(RTRIM(LTRIM([MaxQtyPerMedia])), '')
		, NULLIF(RTRIM(LTRIM([Media])), '')
		, NULLIF(RTRIM(LTRIM([RoHsCompliant])), '')
		, NULLIF(RTRIM(LTRIM([LotNo])), '')
		, NULLIF(RTRIM(LTRIM([FullMediaReqd])), '')
		, NULLIF(RTRIM(LTRIM([SupplierPartNumber])), '')
		, NULLIF(RTRIM(LTRIM([IntelMaterialPn])), '')
		, NULLIF(RTRIM(LTRIM([TestUpi])), '')
		, NULLIF(RTRIM(LTRIM([PgTierAndSpeedInfo])), '')
		, NULLIF(RTRIM(LTRIM([AssyUpi])), '')
		, NULLIF(RTRIM(LTRIM([DeviceName])), '')
		, NULLIF(RTRIM(LTRIM([Mpp])), '')
		, NULLIF(RTRIM(LTRIM([SortUpi])), '')
		, NULLIF(RTRIM(LTRIM([ReclaimUpi])), '')
		, NULLIF(RTRIM(LTRIM([ReclaimMm])), '')
		, NULLIF(RTRIM(LTRIM([ProductNaming])), '')
		, NULLIF(RTRIM(LTRIM([TwoDidApproved])), '')
		, NULLIF(RTRIM(LTRIM([TwoDidStartedWw])), '')
		, NULLIF(RTRIM(LTRIM([Did])), '')
		, NULLIF(RTRIM(LTRIM([Group])), '')
		, NULLIF(RTRIM(LTRIM([Note])), '')
	FROM @Records;
	-- end: standardization

	-- begin: validation
	SELECT @DesignIdValidated = MIN([Id]) FROM [ref].[DesignFamilies] WITH (NOLOCK) WHERE [Id] = @DesignFamilyId;
	SELECT @OsatIdValidated = MIN([Id]) FROM [qan].[Osats] WITH (NOLOCK) WHERE [Id] = @OsatId;

	IF (@DesignIdValidated IS NULL)
	BEGIN
		SET @Message = 'Invalid design family id: ' + ISNULL(CAST(@DesignFamilyId AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END
	ELSE IF (@OsatIdValidated IS NULL)
	BEGIN
		SET @Message = 'Invalid osat id: ' + ISNULL(CAST(@OsatId AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END
	ELSE IF (@OriginalFileName IS NULL)
	BEGIN
		SET @Message = 'Original filename is required';
		SET @ErrorsExist = 1;
	END
	ELSE IF (@FileLengthInBytes IS NULL)
	BEGIN
		SET @Message = 'File length is required';
		SET @ErrorsExist = 1;
	END;

	-- required values
	INSERT INTO @Messages ([RecordNumber], [FieldName], [MessageType], [Message])
		SELECT [RecordNumber], 'Project', 'Error', 'Required value' FROM @RecordsStandardized WHERE [Project] IS NULL;
	INSERT INTO @Messages ([RecordNumber], [FieldName], [MessageType], [Message])
		SELECT [RecordNumber], 'IntelProdName', 'Error', 'Required value' FROM @RecordsStandardized WHERE [IntelProdName] IS NULL;
	INSERT INTO @Messages ([RecordNumber], [FieldName], [MessageType], [Message])
		SELECT [RecordNumber], 'IntelLevel1PartNumber', 'Error', 'Required value' FROM @RecordsStandardized WHERE [IntelLevel1PartNumber] IS NULL;
	INSERT INTO @Messages ([RecordNumber], [FieldName], [MessageType], [Message])
		SELECT [RecordNumber], 'SpecNumberField', 'Error', 'Required value' FROM @RecordsStandardized WHERE [SpecNumberField] IS NULL;
	INSERT INTO @Messages ([RecordNumber], [FieldName], [MessageType], [Message])
		SELECT [RecordNumber], 'MaterialMasterField', 'Error', 'Required value' FROM @RecordsStandardized WHERE [MaterialMasterField] IS NULL;
	INSERT INTO @Messages ([RecordNumber], [FieldName], [MessageType], [Message])
		SELECT [RecordNumber], 'AssyUpi', 'Error', 'Required value' FROM @RecordsStandardized WHERE [AssyUpi] IS NULL;
	INSERT INTO @Messages ([RecordNumber], [FieldName], [MessageType], [Message])
		SELECT [RecordNumber], 'DeviceName', 'Error', 'Required value' FROM @RecordsStandardized WHERE [DeviceName] IS NULL;
	-- required values (conditional)
	INSERT INTO @Messages ([RecordNumber], [FieldName], [MessageType], [Message])
		SELECT [RecordNumber], 'IntelMaterialPn', 'Error', 'Required value when Project = Test' FROM @RecordsStandardized WHERE [IntelMaterialPn] IS NULL AND [Project] = 'Test';
	-- duplicate records
	WITH Duplicates AS
	(
		SELECT *, rn = ROW_NUMBER() OVER (PARTITION BY [MaterialMasterField], [AssyUpi] ORDER BY [RecordNumber]) FROM @RecordsStandardized WHERE [MaterialMasterField] IS NOT NULL AND [AssyUpi] IS NOT NULL
	)
	INSERT INTO @Messages ([RecordNumber], [MessageType], [Message])
		SELECT [RecordNumber], 'Error', 'Duplicate record' FROM Duplicates WHERE rn > 1;
	-- make sure parsed values are supported
	INSERT INTO @Messages ([RecordNumber], [FieldName], [MessageType], [Message])
		SELECT [RecordNumber], 'IntelProdName', 'Error', [Message]
		FROM
		(
			SELECT
				  Z.*
				, DT.[PackageDieCount]
				, [Message] = 'Unsupported package die type' + ISNULL(': ' + Z.[PackageDieType], '')
			FROM
			(
				SELECT
					  *
					, [PackageDieType] = [qan].[FParseOsatPackageDieTypeFromIntelProdName]([IntelProdName])
				FROM @RecordsStandardized
			) AS Z
			LEFT OUTER JOIN [qan].[OsatPackageDieTypes] AS DT WITH (NOLOCK) ON (DT.[Name] = Z.[PackageDieType])
			WHERE DT.[Id] IS NULL
		) AS T;
	-- end: validation

	IF (@ErrorsExist = 0)
	BEGIN
		-- begin: data creation
		BEGIN TRANSACTION
			-- determine if combination exists
			SELECT @CombinationId = MAX([Id]) FROM [qan].[OsatPasCombinations] WITH (NOLOCK) WHERE [OsatId] = @OsatId AND [DesignFamilyId] = @DesignFamilyId;
			IF (@CombinationId IS NULL)
			BEGIN
				-- insert combination
				INSERT INTO [qan].[OsatPasCombinations]
				(
					  [OsatId]
					, [DesignFamilyId]
					, [CreatedBy]
					, [UpdatedBy]
				)
				VALUES
				(
					  @OsatId             -- [OsatId]
					, @DesignFamilyId     -- [DesignFamilyId]
					, @UserId             -- [CreatedBy]
					, @UserId             -- [UpdatedBy]
				);
				SELECT @CombinationId = SCOPE_IDENTITY();
			END;

			-- insert version
			SELECT @Version = (ISNULL(MAX([Version]), 0) + 1) FROM [qan].[OsatPasVersions] WITH (NOLOCK) WHERE [CombinationId] = @CombinationId;
			INSERT INTO [qan].[OsatPasVersions]
			(
				  [Version]
				, [StatusId]
				, [CreatedBy]
				, [UpdatedBy]
				, [CombinationId]
				, [OriginalFileName]
				, [FileLengthInBytes]
			)
			VALUES
			(
				  @Version            -- [Version]
				, 1                   -- [StatusId] (1 = Draft)
				, @UserId             -- [CreatedBy]
				, @UserId             -- [UpdatedBy]
				, @CombinationId      -- [CombinationId]
				, @OriginalFileName   -- [OriginalFileName]
				, @FileLengthInBytes  -- [FileLengthInBytes]
			);
			SELECT @Id = SCOPE_IDENTITY();

			-- insert version records (with no errors)
			INSERT INTO [qan].[OsatPasVersionRecords]
			(
				  [VersionId]
				, [RecordNumber]
				, [ProductGroup]
				, [Project]
				, [IntelProdName]
				, [IntelLevel1PartNumber]
				, [Line1TopSideMarking]
				, [CopyrightYear]
				, [SpecNumberField]
				, [MaterialMasterField]
				, [MaxQtyPerMedia]
				, [Media]
				, [RoHsCompliant]
				, [LotNo]
				, [FullMediaReqd]
				, [SupplierPartNumber]
				, [IntelMaterialPn]
				, [TestUpi]
				, [PgTierAndSpeedInfo]
				, [AssyUpi]
				, [DeviceName]
				, [Mpp]
				, [SortUpi]
				, [ReclaimUpi]
				, [ReclaimMm]
				, [ProductNaming]
				, [TwoDidApproved]
				, [TwoDidStartedWw]
				, [Did]
				, [Group]
				, [Note]
			)
			SELECT
				  @Id
				, [RecordNumber]
				, [ProductGroup]
				, [Project]
				, [IntelProdName]
				, [IntelLevel1PartNumber]
				, [Line1TopSideMarking]
				, [CopyrightYear]
				, [SpecNumberField]
				, [MaterialMasterField]
				, [MaxQtyPerMedia]
				, [Media]
				, [RoHsCompliant]
				, [LotNo]
				, [FullMediaReqd]
				, [SupplierPartNumber]
				, [IntelMaterialPn]
				, [TestUpi]
				, [PgTierAndSpeedInfo]
				, [AssyUpi]
				, [DeviceName]
				, [Mpp]
				, [SortUpi]
				, [ReclaimUpi]
				, [ReclaimMm]
				, [ProductNaming]
				, [TwoDidApproved]
				, [TwoDidStartedWw]
				, [Did]
				, [Group]
				, [Note]
			FROM @RecordsStandardized
			WHERE [RecordNumber] NOT IN (SELECT [RecordNumber] FROM @Messages WHERE [MessageType] = 'Error');

			-- insert version import messages
			INSERT INTO [qan].[OsatPasVersionImportMessages]
			(
				  [VersionId]
				, [RecordId]
				, [RecordNumber]
				, [MessageType]
				, [FieldName]
				, [Message]
			)
			SELECT
				  @Id
				, R.[Id]
				, M.[RecordNumber]
				, M.[MessageType]
				, M.[FieldName]
				, M.[Message]
			FROM @Messages AS M
			LEFT OUTER JOIN [qan].[OsatPasVersionRecords] AS R WITH (NOLOCK) ON (R.[RecordNumber] = M.[RecordNumber] AND R.[VersionId] = @Id);
		COMMIT;
		SET @Succeeded = 1;
		-- end: data creation
	END;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', @ActionType, 'OsatPasVersion', @Id, NULL, @Succeeded, @Message, 'OsatPasCombination', @CombinationId;

END
