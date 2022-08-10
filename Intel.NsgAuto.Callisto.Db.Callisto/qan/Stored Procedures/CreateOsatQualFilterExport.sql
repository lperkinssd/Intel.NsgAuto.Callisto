-- ====================================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-08 14:45:37.170
-- Description  : Creates a new auto checker qual filter export. After execution, if the output parameter @Id is null, then the export was not created
--                and @Message contains the reason.
-- Example      : DECLARE @Id        INT;
--                DECLARE @Message  VARCHAR(500);
--                DECLARE @DesignIds [qan].[IInts];
--                DECLARE @OsatIds   [qan].[IInts];
--                EXEC [qan].[CreateOsatQualFilterExport] @Id OUTPUT, @Message OUTPUT, 'bricschx', @DesignIds, @OsatIds, 0;
--                PRINT 'Id = ' + ISNULL(CAST(@Id AS VARCHAR(20)), 'null') + '; Message = ' + ISNULL(@Message, 'null');
--                -- should print: Id = null; Message = There is no associated data to export
-- ====================================================================================================================================================
CREATE PROCEDURE [qan].[CreateOsatQualFilterExport]
(
	  @Id             INT                  OUTPUT
	, @Message        VARCHAR(500)         OUTPUT
	, @UserId         VARCHAR(25)
	, @DesignIds      [qan].[IInts]        READONLY
	, @OsatIds        [qan].[IInts]        READONLY
	, @Comprehensive  BIT           = 1
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionDescription  VARCHAR (1000) = 'Create';
	DECLARE @Count              INT;
	DECLARE @ErrorsExist        BIT            = 0;
	DECLARE @On                 DATETIME2(7)   = GETUTCDATE();
	DECLARE @Succeeded          BIT            = 0;

	-- standardization
	SET @Id = NULL;
	SET @Message = NULL;
	IF (@Comprehensive IS NULL) SET @Comprehensive = 1;

	-- empty recordset just to create the temporary table with the proper structure
	IF OBJECT_ID('tempdb..#OsatQualFilterFileRecords') IS NOT NULL DROP TABLE #OsatQualFilterFileRecords;

	SELECT * INTO #OsatQualFilterFileRecords FROM [qan].[FOsatQualFilterRecords](0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL) WHERE 0 = 1;

	IF (@Comprehensive = 1)
	BEGIN
		INSERT INTO #OsatQualFilterFileRecords SELECT * FROM [qan].[FOsatQualFilterRecords](NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL) WHERE [OsatId]   IN(1,2);
	END;
	ELSE
	BEGIN
		INSERT INTO #OsatQualFilterFileRecords SELECT * FROM [qan].[FOsatQualFilterRecords](NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
		WHERE
			    [DesignId] IN (SELECT [Value] FROM @DesignIds)
			AND [OsatId]   IN (SELECT [Value] FROM @OsatIds);

		 
	END;

	-- begin validation
	SELECT @Count = COUNT(*) FROM #OsatQualFilterFileRecords;
	IF (@Count <= 0)
	BEGIN
		SET @Message = 'There is no associated data to export';
		SET @ErrorsExist = 1;
	END
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION

			INSERT INTO [qan].[OsatQualFilterExports]
			(
				  [CreatedBy]
				, [CreatedOn]
				, [UpdatedBy]
				, [UpdatedOn]
			)
			VALUES
			(
				  @UserId
				, @On
				, @UserId
				, @On
			);

			SELECT @Id = SCOPE_IDENTITY();

			INSERT INTO [qan].[OsatQualFilterExportFiles]
			(
				  [ExportId]
				, [OsatId]
				, [DesignId]
				, [CreatedBy]
				, [CreatedOn]
				, [UpdatedBy]
				, [UpdatedOn]
				, [Name]
			)
			SELECT
				  @Id        -- [ExportId]
				, [OsatId]   -- [OsatId]
				, [DesignId] -- [DesignId]
				, @UserId    -- [CreatedBy]
				, @On        -- [CreatedOn]
				, @UserId    -- [UpdatedBy]
				, @On        -- [UpdatedOn]
				, ISNULL([DesignFamilyName], '') + '_' + ISNULL([DesignName], '') + '_QF_' + ISNULL([OsatName], '') + '_' + FORMAT(@On, 'yyyyMMddHHmmss') + '.xlsx'
			FROM #OsatQualFilterFileRecords GROUP BY [OsatId], [OsatName], [DesignId], [DesignName], [DesignFamilyName] ORDER BY [OsatId], [DesignId];

		


			INSERT INTO [qan].[OsatQualFilterExportFileRecords]
			(
				  [ExportId]
				, [ExportFileId]
				, [BuildCriteriaId]
				, [BuildCriteriaSetId]
				, [BuildCriteriaSetStatusId]
				, [BuildCriteriaSetStatusName]
				, [BuildCriteriaOrdinal]
				, [OsatId]
				, [OsatName]
				, [DesignId]
				, [DesignName]
				, [DesignFamilyId]
				, [DesignFamilyName]
				, [PackageDieTypeId]
				, [PackageDieTypeName]
				, [FilterDescription]
				, [DeviceName]
				, [PartNumberDecode]
				, [IntelLevel1PartNumber]
				, [IntelProdName]
				, [MaterialMasterField]
				, [AssyUpi]
				, [IsEngineeringSample]
				, [av_apo_number]
				, [av_app_restriction]
				, [av_ate_tape_revision]
				, [av_burn_flow]
				, [av_burn_tape_revision]
				, [av_cell_revision]
				, [av_cmos_revision]
				, [av_country_of_assembly]
				, [av_custom_testing_reqd]
				, [av_design_id]
				, [av_device]
				, [av_fab_conv_id]
				, [av_fab_excr_id]
				, [av_fabrication_facility]
				, [av_lead_count]
				, [av_major_probe_prog_rev]
				, [av_marketing_speed]
				, [av_non_shippable]
				, [av_num_array_decks]
				, [av_num_flash_ce_pins]
				, [av_num_io_channels]
				, [av_number_of_die_in_pkg]
				, [av_pgtier]
				, [av_prb_conv_id]
				, [av_product_grade]
				, [av_reticle_wave_id]
			)
			SELECT
				  @Id
				, F.[Id]
				, R.[BuildCriteriaId]
				, R.[BuildCriteriaSetId]
				, R.[BuildCriteriaSetStatusId]
				, R.[BuildCriteriaSetStatusName]
				, R.[BuildCriteriaOrdinal]
				, R.[OsatId]
				, R.[OsatName]
				, R.[DesignId]
				, R.[DesignName]
				, R.[DesignFamilyId]
				, R.[DesignFamilyName]
				, R.[PackageDieTypeId]
				, R.[PackageDieTypeName]
				, R.[FilterDescription]
				, R.[DeviceName]
				, R.[PartNumberDecode]
				, R.[IntelLevel1PartNumber]
				, R.[IntelProdName]
				, R.[MaterialMasterField]
				, R.[AssyUpi]
				, R.[IsEngineeringSample]
				, R.[av_apo_number]
				, R.[av_app_restriction]
				, R.[av_ate_tape_revision]
				, R.[av_burn_flow]
				, R.[av_burn_tape_revision]
				, R.[av_cell_revision]
				, R.[av_cmos_revision]
				, R.[av_country_of_assembly]
				, R.[av_custom_testing_reqd]
				, R.[av_design_id]
				, R.[av_device]
				, R.[av_fab_conv_id]
				, R.[av_fab_excr_id]
				, R.[av_fabrication_facility]
				, R.[av_lead_count]
				, R.[av_major_probe_prog_rev]
				, R.[av_marketing_speed]
				, R.[av_non_shippable]
				, R.[av_num_array_decks]
				, R.[av_num_flash_ce_pins]
				, R.[av_num_io_channels]
				, R.[av_number_of_die_in_pkg]
				, R.[av_pgtier]
				, R.[av_prb_conv_id]
				, R.[av_product_grade]
				, R.[av_reticle_wave_id]
			FROM #OsatQualFilterFileRecords AS R
			LEFT OUTER JOIN [qan].[OsatQualFilterExportFiles] AS F WITH (NOLOCK) ON (F.[OsatId] = R.[OsatId] AND F.[DesignId] = R.[DesignId])
			WHERE F.[ExportId] = @Id ORDER BY F.[Id], R.[PackageDieTypeId], [BuildCriteriaSetId], [BuildCriteriaId];

		COMMIT;

		SET @Succeeded = 1;
	END;

	DROP TABLE #OsatQualFilterFileRecords;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', 'Create', 'OsatQualFilterExport', @Id, NULL, @Succeeded, @Message;

END
