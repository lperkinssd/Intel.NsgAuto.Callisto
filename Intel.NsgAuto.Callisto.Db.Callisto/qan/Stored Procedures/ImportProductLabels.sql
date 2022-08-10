-- =================================================================
-- Author       : bricschx
-- Create date  : 2020-08-19 17:50:11.917
-- Description  : Performs a product label import
-- Example      : EXEC [qan].[ImportProductLabels] @UserId, @Records
-- =================================================================
CREATE PROCEDURE [qan].[ImportProductLabels]
(
	  @UserId VARCHAR(25)
	, @Records [qan].[IProductLabelsImport] READONLY
)
AS
BEGIN

	DECLARE @Count INT;
	DECLARE @Messages [qan].[IImportMessages];
	DECLARE @On DATETIME2(7) = GETUTCDATE();
	DECLARE @ProductLabelId BIGINT;
	DECLARE @RecordCount INT;
	DECLARE @RecordNumber INT = 1;
	DECLARE @RecordsStandardized [qan].[IProductLabelsImport];
	DECLARE @Value VARCHAR(500);
	DECLARE @Version INT;
	DECLARE @VersionId INT;
	DECLARE @VersionStatusId INT;

	SET NOCOUNT ON;
	
	SELECT @Version = (ISNULL(MAX([Version]), 0) + 1) FROM [qan].[ProductLabelSetVersions] WITH (NOLOCK);
	SELECT @RecordCount = COUNT(*) FROM @Records;


	-- Step 1: Standardization
	-- All pertinent fields trimmed and converted to null if empty string
	-- Note: This simplifies subsequent code as all that is required is a null check for empty fields
	INSERT INTO @RecordsStandardized
	SELECT
		  [RecordNumber]
		, NULLIF(RTRIM(LTRIM([ProductFamily])), '')
		, NULLIF(RTRIM(LTRIM([Customer])), '')
		, NULLIF(RTRIM(LTRIM([ProductionProductCode])), '')
		, NULLIF(RTRIM(LTRIM([ProductFamilyNameSeries])), '')
		, NULLIF(RTRIM(LTRIM([Capacity])), '')
		, NULLIF(RTRIM(LTRIM([ModelString])), '')
		, NULLIF(RTRIM(LTRIM([VoltageCurrent])), '')
		, NULLIF(RTRIM(LTRIM([InterfaceSpeed])), '')
		, NULLIF(RTRIM(LTRIM([OpalType])), '')
		, NULLIF(RTRIM(LTRIM([KCCId])), '')
		, NULLIF(RTRIM(LTRIM([CanadianStringClass])), '')
		, NULLIF(RTRIM(LTRIM([DellPN])), '')
		, NULLIF(RTRIM(LTRIM([DellPPIDRev])), '')
		, NULLIF(RTRIM(LTRIM([DellEMCPN])), '')
		, NULLIF(RTRIM(LTRIM([DellEMCPNRev])), '')
		, NULLIF(RTRIM(LTRIM([HpePN])), '')
		, NULLIF(RTRIM(LTRIM([HpeModelString])), '')
		, NULLIF(RTRIM(LTRIM([HpeGPN])), '')
		, NULLIF(RTRIM(LTRIM([HpeCTAssemblyCode])), '')
		, NULLIF(RTRIM(LTRIM([HpeCTRev])), '')
		, NULLIF(RTRIM(LTRIM([HpPN])), '')
		, NULLIF(RTRIM(LTRIM([HpCTAssemblyCode])), '')
		, NULLIF(RTRIM(LTRIM([HpCTRev])), '')
		, NULLIF(RTRIM(LTRIM([LenovoFRU])), '')
		, NULLIF(RTRIM(LTRIM([Lenovo8ScodePN])), '')
		, NULLIF(RTRIM(LTRIM([Lenovo8ScodeBCH])), '')
		, NULLIF(RTRIM(LTRIM([Lenovo11ScodePN])), '')
		, NULLIF(RTRIM(LTRIM([Lenovo11ScodeRev])), '')
		, NULLIF(RTRIM(LTRIM([Lenovo11ScodePN10])), '')
		, NULLIF(RTRIM(LTRIM([OracleProductIdentifer])), '')
		, NULLIF(RTRIM(LTRIM([OraclePN])), '')
		, NULLIF(RTRIM(LTRIM([OraclePNRev])), '')
		, NULLIF(RTRIM(LTRIM([OracleModel])), '')
		, NULLIF(RTRIM(LTRIM([OraclePkgPN])), '')
		, NULLIF(RTRIM(LTRIM([OracleMarketingPN])), '')
		, NULLIF(RTRIM(LTRIM([CiscoPN])), '')
		, NULLIF(RTRIM(LTRIM([FujistuCSL])), '')
		, NULLIF(RTRIM(LTRIM([Fujitsu106PN])), '')
		, NULLIF(RTRIM(LTRIM([HitachiModelName])), '')
	FROM @Records;


	-- Step 2: Validation
	-- ProductionProductCode: Required value
	INSERT INTO @Messages SELECT [RecordNumber], 'ProductionProductCode' AS [FieldName], 'Error' AS [MessageType], 'Required value' AS [Message] FROM @RecordsStandardized WHERE [ProductionProductCode] IS NULL;

	-- ProductFamily: Invalid value
	INSERT INTO @Messages SELECT [RecordNumber], 'ProductFamily' AS [FieldName], 'Error' AS [MessageType], 'Invalid value' AS [Message] FROM @RecordsStandardized WHERE [ProductFamily] IS NOT NULL AND [ProductFamily] NOT IN (SELECT [Name] FROM [qan].[ProductFamilies] WITH (NOLOCK));

	-- Customer: Invalid value
	INSERT INTO @Messages SELECT [RecordNumber], 'Customer' AS [FieldName], 'Error' AS [MessageType], 'Invalid value' AS [Message] FROM @RecordsStandardized WHERE [Customer] IS NOT NULL AND [Customer] NOT IN (SELECT [Name] FROM [qan].[Customers] WITH (NOLOCK));

	-- ProductionProductCode: Duplicate value
	WITH Duplicates AS
	(
		SELECT *, rn = ROW_NUMBER() OVER (PARTITION BY [ProductionProductCode] ORDER BY [RecordNumber]) FROM @RecordsStandardized WHERE [ProductionProductCode] IS NOT NULL
	)
	INSERT INTO @Messages SELECT [RecordNumber], 'ProductionProductCode' AS [FieldName], 'Error' AS [MessageType], 'Duplicate value' AS [Message] FROM Duplicates WHERE rn > 1;

	-- Capacity: Required value
	INSERT INTO @Messages SELECT [RecordNumber], 'Capacity' AS [FieldName], 'Error' AS [MessageType], 'Required value' AS [Message] FROM @RecordsStandardized WHERE [Capacity] IS NULL;

	-- ModelString: Required value
	INSERT INTO @Messages SELECT [RecordNumber], 'ModelString' AS [FieldName], 'Error' AS [MessageType], 'Required value' AS [Message] FROM @RecordsStandardized WHERE [ModelString] IS NULL;

	-- OpalType: Required value
	INSERT INTO @Messages SELECT [RecordNumber], 'OpalType' AS [FieldName], 'Error' AS [MessageType], 'Required value' AS [Message] FROM @RecordsStandardized WHERE [OpalType] IS NULL;

	-- OpalType: Invalid value
	INSERT INTO @Messages SELECT [RecordNumber], 'OpalType' AS [FieldName], 'Error' AS [MessageType], 'Invalid value' AS [Message] FROM @RecordsStandardized WHERE [OpalType] IS NOT NULL AND [OpalType] NOT IN (SELECT [Name] FROM [ref].[OpalTypes] WITH (NOLOCK));


	-- Step 3: Data Creation
	-- Create records in associated tables
	MERGE [qan].[ProductFamilyNameSeries] AS M
	USING (SELECT DISTINCT [ProductFamilyNameSeries] FROM @RecordsStandardized WHERE [ProductFamilyNameSeries] IS NOT NULL) AS R
	ON (M.[Name] = R.[ProductFamilyNameSeries])
	WHEN NOT MATCHED THEN INSERT ([Name]) VALUES (R.[ProductFamilyNameSeries]);

	-- Create version record
	SELECT @VersionStatusId = MIN([Id]) FROM [ref].[Statuses] WHERE [Name] = 'Draft';

	INSERT INTO [qan].[ProductLabelSetVersions]
		([Version], [StatusId], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn])
		VALUES
		(@Version, @VersionStatusId, @UserId, @On, @UserId, @On);

	SELECT @VersionId = SCOPE_IDENTITY();

	-- Create records (with no errors)
	WHILE @RecordNumber <= @RecordCount
	BEGIN

		SELECT @Count = COUNT(*) FROM @Messages WHERE [RecordNumber] = @RecordNumber AND [MessageType] = 'Error';

		IF @Count = 0
		BEGIN
			INSERT INTO [qan].[ProductLabels]
			(
				  [ProductLabelSetVersionId]
				, [ProductionProductCode]
				, [ProductFamilyId]
				, [CustomerId]
				, [ProductFamilyNameSeriesId]
				, [Capacity]
				, [ModelString]
				, [VoltageCurrent]
				, [InterfaceSpeed]
				, [OpalTypeId]
				, [KCCId]
				, [CanadianStringClass]
				, [CreatedBy]
				, [CreatedOn]
				, [UpdatedBy]
				, [UpdatedOn]
			)
			SELECT
				  @VersionId
				, R.[ProductionProductCode]
				, PF.[Id]
				, C.[Id]
				, NS.[Id]
				, R.[Capacity]
				, R.[ModelString]
				, R.[VoltageCurrent]
				, R.[InterfaceSpeed]
				, OT.[Id]
				, R.[KCCId]
				, R.[CanadianStringClass]
				, @UserId
				, @On
				, @UserId
				, @On
			FROM @RecordsStandardized AS R
			LEFT JOIN [qan].[ProductFamilies] AS PF WITH (NOLOCK)
				ON (R.[ProductFamily] = PF.[Name])
			LEFT JOIN [qan].[Customers] AS C WITH (NOLOCK)
				ON (R.[Customer] = C.[Name])
			LEFT JOIN [qan].[ProductFamilyNameSeries] AS NS WITH (NOLOCK)
				ON (R.[ProductFamilyNameSeries] = NS.[Name])
			LEFT JOIN [ref].[OpalTypes] AS OT WITH (NOLOCK)
				ON (R.[OpalType] = OT.[Name])
			WHERE R.[RecordNumber] = @RecordNumber;

			SELECT @ProductLabelId = SCOPE_IDENTITY();

			SELECT @Count = COUNT(*), @Value = MIN([DellPN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [DellPN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'DellPN', @Value, @UserId, @On;
			END

			SELECT @Count = COUNT(*), @Value = MIN([DellPPIDRev]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [DellPPIDRev] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'DellPPIDRev', @Value, @UserId, @On;
			END

			SELECT @Count = COUNT(*), @Value = MIN([DellEMCPN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [DellEMCPN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'DellEMCPN', @Value, @UserId, @On;
			END

			SELECT @Count = COUNT(*), @Value = MIN([DellEMCPNRev]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [DellEMCPNRev] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'DellEMCPNRev', @Value, @UserId, @On;
			END

			--HPE PN
			SELECT @Count = COUNT(*), @Value = MIN([HpePN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [HpePN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'HpePN', @Value, @UserId, @On;
			END

			--HPE Model String
			SELECT @Count = COUNT(*), @Value = MIN([HpeModelString]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [HpeModelString] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'HpeModelString', @Value, @UserId, @On;
			END

			--HPE GPN
			SELECT @Count = COUNT(*), @Value = MIN([HpeGPN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [HpeGPN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'HpeGPN', @Value, @UserId, @On;
			END

			--HPE CT# Assembly Code
			SELECT @Count = COUNT(*), @Value = MIN([HpeCTAssemblyCode]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [HpeCTAssemblyCode] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'HpeCTAssemblyCode', @Value, @UserId, @On;
			END

			--HPE CT# Rev
			SELECT @Count = COUNT(*), @Value = MIN([HpeCTRev]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [HpeCTRev] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'HpeCTRev', @Value, @UserId, @On;
			END

			--HP PN
			SELECT @Count = COUNT(*), @Value = MIN([HpPN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [HpPN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'HpPN', @Value, @UserId, @On;
			END

			--HP CT# Assembly Code
			SELECT @Count = COUNT(*), @Value = MIN([HpCTAssemblyCode]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [HpCTAssemblyCode] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'HpCTAssemblyCode', @Value, @UserId, @On;
			END

			--HP CT# Rev
			SELECT @Count = COUNT(*), @Value = MIN([HpCTRev]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [HpCTRev] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'HpCTRev', @Value, @UserId, @On;
			END

			--Lenovo FRU
			SELECT @Count = COUNT(*), @Value = MIN([LenovoFRU]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [LenovoFRU] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'LenovoFRU', @Value, @UserId, @On;
			END

			--Lenovo 8S Code PN
			SELECT @Count = COUNT(*), @Value = MIN([Lenovo8ScodePN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [Lenovo8ScodePN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'Lenovo8ScodePN', @Value, @UserId, @On;
			END

			--Lenovo 8S Code BCH
			SELECT @Count = COUNT(*), @Value = MIN([Lenovo8ScodeBCH]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [Lenovo8ScodeBCH] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'Lenovo8ScodeBCH', @Value, @UserId, @On;
			END

			--Lenovo 11S Code PN
			SELECT @Count = COUNT(*), @Value = MIN([Lenovo11ScodePN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [Lenovo11ScodePN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'Lenovo11ScodePN', @Value, @UserId, @On;
			END

			--Lenovo 11S Code Rev
			SELECT @Count = COUNT(*), @Value = MIN([Lenovo11ScodeRev]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [Lenovo11ScodeRev] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'Lenovo11ScodeRev', @Value, @UserId, @On;
			END

			--Lenovo 11S Code PN
			SELECT @Count = COUNT(*), @Value = MIN([Lenovo11ScodePN10]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [Lenovo11ScodePN10] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'Lenovo11ScodePN10', @Value, @UserId, @On;
			END

			--Oracle Product Identifer
			SELECT @Count = COUNT(*), @Value = MIN([OracleProductIdentifer]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [OracleProductIdentifer] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'OracleProductIdentifer', @Value, @UserId, @On;
			END

			--Oracle PN
			SELECT @Count = COUNT(*), @Value = MIN([OraclePN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [OraclePN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'OraclePN', @Value, @UserId, @On;
			END

			--Oracle PN Rev
			SELECT @Count = COUNT(*), @Value = MIN([OraclePNRev]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [OraclePNRev] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'OraclePNRev', @Value, @UserId, @On;
			END

			--Oracle Model
			SELECT @Count = COUNT(*), @Value = MIN([OracleModel]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [OracleModel] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'OracleModel', @Value, @UserId, @On;
			END

			--Oracle PKG PN
			SELECT @Count = COUNT(*), @Value = MIN([OraclePkgPN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [OraclePkgPN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'OraclePkgPN', @Value, @UserId, @On;
			END

			--Oracle Marketing PN
			SELECT @Count = COUNT(*), @Value = MIN([OracleMarketingPN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [OracleMarketingPN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'OracleMarketingPN', @Value, @UserId, @On;
			END

			--Cisco PN
			SELECT @Count = COUNT(*), @Value = MIN([CiscoPN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [CiscoPN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'CiscoPN', @Value, @UserId, @On;
			END

			--Fujistu CSL
			SELECT @Count = COUNT(*), @Value = MIN([FujistuCSL]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [FujistuCSL] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'FujistuCSL', @Value, @UserId, @On;
			END

			--Fujitsu 106 PN
			SELECT @Count = COUNT(*), @Value = MIN([Fujitsu106PN]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [Fujitsu106PN] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'Fujitsu106PN', @Value, @UserId, @On;
			END

			--Hitachi Model Name
			SELECT @Count = COUNT(*), @Value = MIN([HitachiModelName]) FROM @RecordsStandardized WHERE [RecordNumber] = @RecordNumber AND [HitachiModelName] IS NOT NULL;
			IF @Count > 0
			BEGIN
				EXEC [qan].[CreateProductLabelAttribute] NULL, @ProductLabelId, 'HitachiModelName', @Value, @UserId, @On;
			END

		END

		SET @RecordNumber = @RecordNumber + 1;

	END

	-- Step 4: Output
	SELECT * FROM @Messages;

	EXEC [qan].[GetProductLabelSetVersions] @UserId, @VersionId, null

END
