-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-28 13:21:51.103
-- Description  : Creates the product label attribute types
-- Example      : EXEC [setup].[CreateProductLabelAttributeTypes];
--                SELECT * FROM [ref].[ProductLabelAttributeTypes];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateProductLabelAttributeTypes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[ProductLabelAttributeTypes]';
	BEGIN
		TRUNCATE TABLE [ref].[ProductLabelAttributeTypes];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[ProductLabelAttributeTypes] ON;

		INSERT [ref].[ProductLabelAttributeTypes] ([Id], [Name], [NameDisplay])
		VALUES
			  (1, 'DellPN', 'DELL PN')
			, (2, 'DellPPIDRev', 'DELL PPID Rev')
			, (3, 'DellEMCPN', 'DELL EMC PN')
			, (4, 'DellEMCPNRev', 'DELL EMC PN Rev')
			, (5, 'HpePN', 'HPE PN')
			, (6, 'HpeModelString', 'HPE Model String')
			, (7, 'HpeGPN', 'HPE GPN')
			, (8, 'HpeCTAssemblyCode', 'HPE CT# Assembly Code')
			, (9, 'HpeCTRev', 'HPE CT# Rev')
			, (10, 'HpPN', 'HP PN')
			, (11, 'HpCTAssemblyCode', 'HP CT# Assembly Code')
			, (12, 'HpCTRev', 'HP CT# Rev')
			, (13, 'LenovoFRU', 'Lenovo FRU')
			, (14, 'Lenovo8ScodePN', 'Lenovo 8S Code PN')
			, (15, 'Lenovo8ScodeBCH', 'Lenovo 8S Code BCH')
			, (16, 'Lenovo11ScodePN', 'Lenovo 11S Code PN')
			, (17, 'Lenovo11ScodeRev', 'Lenovo 11S Code Rev')
			, (18, 'Lenovo11ScodePN10', 'Lenovo 11S Code PN 10 Digits')
			, (19, 'OracleProductIdentifer', 'Oracle Product Identifer')
			, (20, 'OraclePN', 'Oracle PN')
			, (21, 'OraclePNRev', 'Oracle PN Rev')
			, (22, 'OracleModel', 'Oracle Model')
			, (23, 'OraclePkgPN', 'Oracle PKG PN')
			, (24, 'OracleMarketingPN', 'Oracle Marketing PN')
			, (25, 'CiscoPN', 'Cisco PN')
			, (26, 'FujistuCSL', 'Fujistu CSL')
			, (27, 'Fujitsu106PN', 'Fujitsu 106 PN')
			, (28, 'HitachiModelName', 'Hitachi Model Name');

		SET IDENTITY_INSERT [ref].[ProductLabelAttributeTypes] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[ProductLabelAttributeTypes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
