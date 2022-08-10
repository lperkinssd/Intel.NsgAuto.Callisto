-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-01-26 13:10:23.127
-- Description  : Creates new attribute type values from the treadstone data
-- Example      : EXEC [qan].[CreateNewTreadstoneAttributeTypeValues];
-- ============================================================================
CREATE PROCEDURE [qan].[CreateNewTreadstoneAttributeTypeValues]
(
	  @CountInserted INT = NULL OUTPUT
	, @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);

	IF (@By IS NULL) SET @By = [qan].[CreatedByTreadstone]();

	MERGE [qan].[AcAttributeTypeValues] AS M
	USING
	(
		SELECT A.[Id] AS [AttributeTypeId], T.[AttributeTypeName], T.[Value], CASE WHEN NULLIF(LTRIM(RTRIM(T.[Value])), '') IS NULL THEN '(Empty)' ELSE [Value] END AS [ValueDisplay] FROM
		(
			SELECT 'app_restriction' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [app_restriction] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'app_restriction') AS T01
			UNION
			SELECT 'app_restriction' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [app_restriction] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'app_restriction') AS T01
			UNION
			SELECT 'cell_revision' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [cell_revision] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'cell_revision') AS T02
			UNION
			SELECT 'cell_revision' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [cell_revision] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'cell_revision') AS T02
			UNION
			SELECT 'cmos_revision' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [cmos_revision] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'cmos_revision') AS T03
			UNION
			SELECT 'cmos_revision' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [cmos_revision] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'cmos_revision') AS T03
			UNION
			SELECT 'country_of_assembly' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [country_of_assembly] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'country_of_assembly') AS T04
			UNION
			SELECT 'country_of_assembly' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [country_of_assembly] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'country_of_assembly') AS T04
			UNION
			SELECT 'fab_conv_id' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [fab_conv_id] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'fab_conv_id') AS T05
			UNION
			SELECT 'fab_conv_id' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [fab_conv_id] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'fab_conv_id') AS T05
			UNION
			SELECT 'fab_excr_id' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [fab_excr_id] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'fab_excr_id') AS T06
			UNION
			SELECT 'fab_excr_id' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [fab_excr_id] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'fab_excr_id') AS T06
			UNION
			SELECT 'major_probe_prog_rev' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [major_probe_prog_rev] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'major_probe_prog_rev') AS T07
			UNION
			SELECT 'major_probe_prog_rev' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [major_probe_prog_rev] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'major_probe_prog_rev') AS T07
			UNION
			SELECT 'mppr_first' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [mppr_first] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'mppr_first') AS T08
			UNION
			SELECT 'mppr_first' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [mppr_first] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'mppr_first') AS T08
			UNION
			SELECT 'offshore_asm_company' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [offshore_asm_company] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'offshore_asm_company') AS T09
			UNION
			SELECT 'offshore_asm_company' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [offshore_asm_company] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'offshore_asm_company') AS T09
			UNION
			SELECT DISTINCT 'probe_ship_part_type' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT RIGHT([probe_ship_part_type], 3) COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [probe_ship_part_type] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT RIGHT([new_value], 3) COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'probe_ship_part_type' UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'probe_ship_part_type') AS T10
			UNION
			SELECT DISTINCT 'probe_ship_part_type' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT RIGHT([probe_ship_part_type], 3) COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [probe_ship_part_type] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT RIGHT([new_value], 3) COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'probe_ship_part_type' UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'probe_ship_part_type') AS T10
			UNION
			SELECT 'product_grade' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [product_grade] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'product_grade') AS T11
			UNION
			SELECT 'product_grade' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [product_grade] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'product_grade') AS T11
			UNION
			SELECT 'reticle_wave_id' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [reticle_wave_id] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'reticle_wave_id') AS T12
			UNION
			SELECT 'reticle_wave_id' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [reticle_wave_id] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'reticle_wave_id') AS T12
			UNION
			SELECT 'trade_sale' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [trade_sale] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'trade_sale') AS T13
			UNION
			SELECT 'trade_sale' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [trade_sale] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'trade_sale') AS T13
			UNION
			SELECT 'ts_state' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [ts_state] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'ts_state') AS T14
			UNION
			SELECT 'ts_state' AS [AttributeTypeName], [Value] FROM (SELECT DISTINCT [ts_state] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSGPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'ts_state') AS T14
		) AS T
		INNER JOIN [qan].[AcAttributeTypes] AS A ON (A.[Name] = T.[AttributeTypeName])
	) AS N
	ON (M.[AttributeTypeId] = N.[AttributeTypeId] AND M.[Value] = N.[Value])
	WHEN NOT MATCHED THEN INSERT ([AttributeTypeId], [Value], [ValueDisplay], [CreatedBy], [UpdatedBy]) VALUES (N.[AttributeTypeId], N.[Value], N.[ValueDisplay], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @CountInserted = COUNT(*) FROM @Ids;

END