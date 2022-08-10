CREATE TABLE [qan].[OsatQualFilterExportFileRecords] (
	  [Id]                         BIGINT        IDENTITY (1, 1)  NOT NULL
	, [ExportId]                   INT                            NOT NULL
	, [ExportFileId]               INT                            NOT NULL
	, [BuildCriteriaId]            BIGINT                         NOT NULL
	, [BuildCriteriaSetId]         BIGINT                         NOT NULL
	, [BuildCriteriaSetStatusId]   INT                            NOT NULL
	, [BuildCriteriaSetStatusName] VARCHAR(25)                        NULL
	, [BuildCriteriaOrdinal]       INT                            NOT NULL
	, [OsatId]                     INT                                NULL
	, [OsatName]                   VARCHAR(50)                        NULL
	, [DesignId]                   INT                                NULL
	, [DesignName]                 VARCHAR(10)                        NULL
	, [DesignFamilyId]             INT                                NULL
	, [DesignFamilyName]           VARCHAR(10)                        NULL
	, [PackageDieTypeId]           INT                                NULL
	, [PackageDieTypeName]         VARCHAR(10)                        NULL
	, [FilterDescription]          VARCHAR(61)                        NULL
	, [DeviceName]                 VARCHAR(28)                        NULL
	, [PartNumberDecode]           VARCHAR(100)                       NULL
	, [IntelLevel1PartNumber]      VARCHAR(25)                        NULL
	, [IntelProdName]              VARCHAR(100)                       NULL
	, [MaterialMasterField]        VARCHAR(10)                        NULL
	, [AssyUpi]                    VARCHAR(25)                        NULL
	, [IsEngineeringSample]        INT                            NOT NULL
	, [av_apo_number]              VARCHAR(4000)                      NULL
	, [av_app_restriction]         VARCHAR(4000)                      NULL
	, [av_ate_tape_revision]       VARCHAR(4000)                      NULL
	, [av_burn_flow]               VARCHAR(4000)                      NULL
	, [av_burn_tape_revision]      VARCHAR(4000)                      NULL
	, [av_cell_revision]           VARCHAR(4000)                      NULL
	, [av_cmos_revision]           VARCHAR(4000)                      NULL
	, [av_country_of_assembly]     VARCHAR(4000)                      NULL
	, [av_custom_testing_reqd]     VARCHAR(4000)                      NULL
	, [av_design_id]               VARCHAR(4000)                      NULL
	, [av_device]                  VARCHAR(4000)                      NULL
	, [av_fab_conv_id]             VARCHAR(4000)                      NULL
	, [av_fab_excr_id]             VARCHAR(4000)                      NULL
	, [av_fabrication_facility]    VARCHAR(4000)                      NULL
	, [av_lead_count]              VARCHAR(4000)                      NULL
	, [av_major_probe_prog_rev]    VARCHAR(4000)                      NULL
	, [av_marketing_speed]         VARCHAR(4000)                      NULL
	, [av_non_shippable]           VARCHAR(4000)                      NULL
	, [av_num_flash_ce_pins]       VARCHAR(4000)                      NULL
	, [av_num_io_channels]         VARCHAR(4000)                      NULL
	, [av_number_of_die_in_pkg]    VARCHAR(4000)                      NULL
	, [av_pgtier]                  VARCHAR(4000)                      NULL
	, [av_prb_conv_id]             VARCHAR(4000)                      NULL
	, [av_product_grade]           VARCHAR(4000)                      NULL
	, [av_reticle_wave_id]         VARCHAR(4000)                      NULL
	, [av_num_array_decks]         VARCHAR(4000)                      NULL
	, CONSTRAINT [PK_OsatQualFilterExportFileRecords] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_OsatQualFilterExportFileRecords_ExportId] ON [qan].[OsatQualFilterExportFileRecords] ([ExportId])

GO

CREATE INDEX [IX_OsatQualFilterExportFileRecords_ExportFileId] ON [qan].[OsatQualFilterExportFileRecords] ([ExportFileId])

GO

CREATE INDEX [IX_OsatQualFilterExportFileRecords_BuildCriteriaId] ON [qan].[OsatQualFilterExportFileRecords] ([BuildCriteriaId])

GO

CREATE INDEX [IX_OsatQualFilterExportFileRecords_BuildCriteriaSetId] ON [qan].[OsatQualFilterExportFileRecords] ([BuildCriteriaSetId])

GO

CREATE INDEX [IX_OsatQualFilterExportFileRecords_OsatId] ON [qan].[OsatQualFilterExportFileRecords] ([OsatId])

GO

CREATE INDEX [IX_OsatQualFilterExportFileRecords_DesignId] ON [qan].[OsatQualFilterExportFileRecords] ([DesignId])

GO
