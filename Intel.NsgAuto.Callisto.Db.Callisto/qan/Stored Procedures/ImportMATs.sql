

-- =============================================================
-- Author		: jakemurx
-- Create date	: 2020-09-09 14:50:11.677
-- Description	: Performs a MAT import
--					EXEC [qan].[ImportMATs] @UserId, @Records
-- =============================================================
CREATE PROCEDURE [qan].[ImportMATs]
(
	    @UserId varchar(25)
	  , @Records [qan].[IMATImport] READONLY
)
AS
BEGIN

	DECLARE @Count int;
	DECLARE @Messages [qan].[IImportMessages];
	DECLARE @On DATETIME2(7) = GETUTCDATE();
	DECLARE @MATId int;
	DECLARE @RecordCount int;
	DECLARE @RecordNumber int = 1;
	DECLARE @RecordsStandardized [qan].[IMATImport];
	DECLARE @Value varchar(128);
	DECLARE @Version int;
	DECLARE @VersionId int;

	SET NOCOUNT ON;
	
	SELECT @Version = (ISNULL(MAX([VersionNumber]), 0) + 1) FROM [qan].[MATVersions] WITH (NOLOCK)
	SELECT @RecordCount = COUNT(*) FROM @Records;

	-- Step 1: Standardization
	-- All pertinent fields trimmed and converted to null if empty string
	-- Note: This simplifies subsequent code as all that is required is a null check for empty fields
	INSERT INTO @RecordsStandardized
	SELECT
		  [RecordNumber]
		, NULLIF(RTRIM(LTRIM([SsdId])), '')
		, NULLIF(RTRIM(LTRIM([DesignId])), '')
		, NULLIF(RTRIM(LTRIM([Scode])), '')
		, NULLIF(RTRIM(LTRIM([CellRevision])), '')
		, NULLIF(RTRIM(LTRIM([MajorProbeProgramRevision])), '')
		, NULLIF(RTRIM(LTRIM([ProbeRevision])), '')
		, NULLIF(RTRIM(LTRIM([BurnTapeRevision])), '')
		, NULLIF(RTRIM(LTRIM([CustomTestingReqd])), '')
		, NULLIF(RTRIM(LTRIM([CustomTestingReqd2])), '')
		, NULLIF(RTRIM(LTRIM([ProductGrade])), '')
		, NULLIF(RTRIM(LTRIM([PrbConvId])), '')
		, NULLIF(RTRIM(LTRIM([FabExcrId])), '')
		, NULLIF(RTRIM(LTRIM([FabConvId])), '')
		, NULLIF(RTRIM(LTRIM([ReticleWaveId])), '')
		, NULLIF(RTRIM(LTRIM([MediaIPN])), '')
		, NULLIF(RTRIM(LTRIM([FabFacility])), '')
		, NULLIF(RTRIM(LTRIM([MediaType])), '')
		, NULLIF(RTRIM(LTRIM([DeviceName])), '')
	FROM @Records;


	-- Step 2: Validation
	-- SsdId: Required value
	INSERT INTO @Messages SELECT [RecordNumber], 'SsdId' AS [FieldName], 'Error' AS [MessageType], 'Required value' AS [Message] FROM @RecordsStandardized WHERE [SsdId] IS NULL;

	-- DesignId: Required value (ProductId)
	INSERT INTO @Messages SELECT [RecordNumber], 'DesignId' AS [FieldName], 'Error' AS [MessageType], 'Required value' AS [Message] FROM @RecordsStandardized WHERE [DesignId] IS NULL;

	-- Scode: Required value
	INSERT INTO @Messages SELECT [RecordNumber], 'Scode' AS [FieldName], 'Error' AS [MessageType], 'Required value' AS [Message] FROM @RecordsStandardized WHERE [Scode] IS NULL;

	-- MediaIPN: Required value
	INSERT INTO @Messages SELECT [RecordNumber], 'MediaIPN' AS [FieldName], 'Error' AS [MessageType], 'Required value' AS [Message] FROM @RecordsStandardized WHERE [MediaIPN] IS NULL;

	-- MediaType: Required value
	INSERT INTO @Messages SELECT [RecordNumber], 'MediaType' AS [FieldName], 'Error' AS [MessageType], 'Required value' AS [Message] FROM @RecordsStandardized WHERE [MediaType] IS NULL;

	-- DeviceName: Required value
	INSERT INTO @Messages SELECT [RecordNumber], 'DeviceName' AS [FieldName], 'Error' AS [MessageType], 'Required value' AS [Message] FROM @RecordsStandardized WHERE [DeviceName] IS NULL;

	-- [Scode], [MediaIPN]: Duplicate value
	WITH Duplicates AS
	(
		SELECT *, rn = ROW_NUMBER() OVER (PARTITION BY [Scode], [MediaIPN] ORDER BY [RecordNumber]) FROM @RecordsStandardized WHERE [Scode] IS NOT NULL AND [MediaIPN] IS NOT NULL
	)
	INSERT INTO @Messages SELECT [RecordNumber], 'Scode, MediaIPN' AS [FieldName], 'Error' AS [MessageType], 'Duplicate value' AS [Message] FROM Duplicates WHERE rn > 1;

	-- Step 3: Data Creation
	-- Create records in associated tables
	MERGE [qan].[MATSSDNames] AS m
	USING (SELECT DISTINCT [SsdId] FROM @RecordsStandardized WHERE [SsdId] IS NOT NULL) AS r
	ON (m.[Name] = r.[SsdId])
	WHEN NOT MATCHED THEN INSERT ([Name]) VALUES (r.[SsdId]);

	MERGE [qan].[Products] AS m
	USING (SELECT DISTINCT [DesignId] FROM @RecordsStandardized WHERE [DesignId] IS NOT NULL) AS r
	ON (m.[Name] = r.[DesignId])
	WHEN NOT MATCHED THEN INSERT ([Name], [CreatedBy], [UpdatedBy]) VALUES (r.[DesignId], @UserId, @UserId);

	DECLARE @VersionStatusId int
	SELECT @VersionStatusId = MIN([Id]) FROM [ref].[Statuses] WHERE [Name] = 'Draft';

	-- Create version record
	INSERT INTO [qan].[MATVersions]
		([VersionNumber], [IsActive], [StatusId], [IsPOR], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn])
		VALUES
		(@Version, 1, @VersionStatusId, 0, @UserId, @On, @UserId, @On);

	SELECT @VersionId = SCOPE_IDENTITY();

	-- Create records (with no errors)
	WHILE @RecordNumber <= @RecordCount
	BEGIN

		SELECT @Count = COUNT(*) FROM @Messages WHERE [RecordNumber] = @RecordNumber AND [MessageType] = 'Error';

		IF @Count = 0
		BEGIN
			INSERT INTO [qan].[MATs]
			(
				  [MATVersionId]
				, [SSDNameId]
				, [ProductId]
				, [SCode]
				, [MediaIPN]
				, [MediaType]
				, [DeviceName]
				, [CreatedBy]
				, [CreatedOn]
				, [UpdatedBy]
				, [UpdatedOn]
			)
			SELECT
				  @VersionId
				, s.[Id]
				, d.[Id]
				, r.[Scode]
				, r.[MediaIPN]
				, r.[MediaType]
				, r.[DeviceName]
				, @UserId
				, @On
				, @UserId
				, @On
			FROM @RecordsStandardized AS r
			LEFT JOIN [qan].[MATSSDNames] AS s WITH (NOLOCK)
				ON (r.[SsdId] = s.[Name])
			LEFT JOIN [qan].[Products] AS d WITH (NOLOCK)
				ON (r.[DesignId] = d.[Name])
			WHERE r.[RecordNumber] = @RecordNumber;

			SELECT @MATId = SCOPE_IDENTITY();

			-- Cell_Revision
			SELECT @Count = COUNT(*), @Value = MIN([CellRevision]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [CellRevision] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'CellRevision', @Value, @UserId, @On
			END

			-- Major_Probe_Program_Revision
			SELECT @Count = COUNT(*), @Value = MIN([MajorProbeProgramRevision]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [MajorProbeProgramRevision] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'MajorProbeProgramRevision', @Value, @UserId, @On
			END

			-- Probe_Revision
			SELECT @Count = COUNT(*), @Value = MIN([ProbeRevision]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [ProbeRevision] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'ProbeRevision', @Value, @UserId, @On
			END

			-- Burn_Tape_Revision
			SELECT @Count = COUNT(*), @Value = MIN([BurnTapeRevision]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [BurnTapeRevision] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'BurnTapeRevision', @Value, @UserId, @On
			END
			
			-- Custom_Testing_Reqd
			SELECT @Count = COUNT(*), @Value = MIN([CustomTestingReqd]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [CustomTestingReqd] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'CustomTestingReqd', @Value, @UserId, @On
			END

			-- Custom_Testing_Reqd2
			SELECT @Count = COUNT(*), @Value = MIN([CustomTestingReqd2]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [CustomTestingReqd2] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'CustomTestingReqd2', @Value, @UserId, @On
			END

			-- Product_Grade
			SELECT @Count = COUNT(*), @Value = MIN([ProductGrade]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [ProductGrade] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'ProductGrade', @Value, @UserId, @On
			END

			-- Prb_Conv_Id
			SELECT @Count = COUNT(*), @Value = MIN([PrbConvId]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [PrbConvId] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'PrbConvId', @Value, @UserId, @On
			END

			-- Fab_Excr_Id
			SELECT @Count = COUNT(*), @Value = MIN([FabExcrId]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [FabExcrId] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'FabExcrId', @Value, @UserId, @On
			END

			-- Fab_Conv_Id
			SELECT @Count = COUNT(*), @Value = MIN([FabConvId]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [FabConvId] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'FabConvId', @Value, @UserId, @On
			END

			-- Reticle_Wave_Id
			SELECT @Count = COUNT(*), @Value = MIN([ReticleWaveId]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [ReticleWaveId] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'ReticleWaveId', @Value, @UserId, @On
			END

			-- Fab_Facility
			SELECT @Count = COUNT(*), @Value = MIN([FabFacility]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [FabFacility] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateMATAttribute] @MATId, 'FabFacility', @Value, @UserId, @On
			END
		END

		SET @RecordNumber = @RecordNumber + 1;

	END

	-- Step 4: Output
	SELECT * FROM @Messages;

	EXEC [qan].[GetMATVersions] @UserId, @VersionId, null

END
