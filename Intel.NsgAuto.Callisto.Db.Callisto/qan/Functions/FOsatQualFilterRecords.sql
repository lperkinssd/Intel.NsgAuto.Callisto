-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-04-15 14:16:48.330
-- Description  : Gets osat qual filter records.
-- Note         : All attribute value columns should use the av_ prefix naming convention followed
--                by their exact attribute type name.
-- Example      : SELECT * FROM [qan].[FOsatQualFilterRecords](1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- ================================================================================================
CREATE FUNCTION [qan].[FOsatQualFilterRecords]
(
	  @DesignId                INT = NULL
	, @OsatId                  INT = NULL
	, @IncludePublishDisabled  BIT = NULL
	, @IncludeStatusInReview   BIT = NULL
	, @IncludeStatusSubmitted  BIT = NULL
	, @IncludeStatusDraft      BIT = NULL
	, @StatusId                INT = NULL
	, @VersionId               INT = NULL
	, @CreatedBy               VARCHAR(25) = NULL
	, @IsPOR			       BIT         = 1
)
RETURNS TABLE AS RETURN
(
	SELECT
		  [Id]                                   = CAST(NULL AS BIGINT)
		, [ExportId]                             = CAST(NULL AS INT)
		, [ExportFileId]                         = CAST(NULL AS INT)
		, [BuildCombinationIsPublishable]        = [BuildCombinationIsPublishable]
		, [BuildCriteriaId]                      = [BuildCriteriaId]
		, [BuildCriteriaSetId]                   = [BuildCriteriaSetId]
		, [BuildCriteriaSetStatusId]             = [BuildCriteriaSetStatusId]
		, [BuildCriteriaSetStatusName]           = [BuildCriteriaSetStatusName]
		, [BuildCriteriaOrdinal]                 = [BuildCriteriaOrdinal]
		, [OsatId]                               = [OsatId]
		, [OsatName]                             = [OsatName]
		, [DesignId]                             = [DesignId]
		, [DesignName]                           = [DesignName]
		, [DesignFamilyId]                       = [DesignFamilyId]
		, [DesignFamilyName]                     = [DesignFamilyName]
		, [PackageDieTypeId]                     = [PackageDieTypeId]
		, [PackageDieTypeName]                   = [PackageDieTypeName]
		, [FilterDescription]                    = [PackageDieTypeName] + ' ' + [BuildCriteriaName]
		, [DeviceName]                           = [IntelLevel1PartNumber] + CASE WHEN ([IsEngineeringSample] = 1 AND [DesignFamilyId] = 2) THEN '-ES' ELSE '' END
		, [PartNumberDecode]                     = CASE [DesignFamilyId] WHEN 1 THEN [Device] ELSE [IntelProdName] END
		, [IntelLevel1PartNumber]                = [IntelLevel1PartNumber]
		, [IntelProdName]                        = [IntelProdName]
		, [MaterialMasterField]                  = [MaterialMasterField]
		, [AssyUpi]                              = [AssyUpi]
		, [IsEngineeringSample]                  = [IsEngineeringSample]
		, [av_apo_number]                        = [apo_number]
		, [av_app_restriction]                   = [app_restriction]
		, [av_ate_tape_revision]                 = [ate_tape_revision]
		, [av_burn_flow]                         = [burn_flow]
		, [av_burn_tape_revision]                = [burn_tape_revision]
		, [av_cell_revision]                     = [cell_revision]
		, [av_cmos_revision]                     = [cmos_revision]
		, [av_country_of_assembly]               = [country_of_assembly]
		, [av_custom_testing_reqd]               = [custom_testing_reqd]
		, [av_design_id]                         = [DesignName]                                                -- not an actual attribute
		, [av_device]                            = CASE [DesignFamilyId] WHEN 2 THEN [Device] ELSE NULL END    -- not an actual attribute
		, [av_fab_conv_id]                       = [fab_conv_id]
		, [av_fab_excr_id]                       = [fab_excr_id]
		, [av_fabrication_facility]              = [fabrication_facility]
		, [av_lead_count]                        = [lead_count]
		, [av_major_probe_prog_rev]              = [major_probe_prog_rev]
		, [av_marketing_speed]                   = [marketing_speed]
		, [av_non_shippable]                     = [non_shippable]
		, [av_num_array_decks]                   = [num_array_decks]
		, [av_num_flash_ce_pins]                 = [num_flash_ce_pins]
		, [av_num_io_channels]                   = [num_io_channels]
		, [av_number_of_die_in_pkg]              = [PackageDieTypeCount]                                       -- not an actual attribute
		, [av_pgtier]                            = [pgtier]
		, [av_prb_conv_id]                       = [prb_conv_id]
		, [av_product_grade]                     = [product_grade]
		, [av_reticle_wave_id]                   = [reticle_wave_id]
	FROM
	(
		SELECT
			  [BuildCombinationIsPublishable]    = CAST(CASE WHEN C.[PublishDisabledOn] IS NOT NULL THEN 0 ELSE 1 END AS BIT)
			, [BuildCriteriaId]                  = BC.[Id]
			, [BuildCriteriaSetId]               = S.[Id]
			, [BuildCriteriaSetStatusId]         = S.[StatusId]
			, [BuildCriteriaSetStatusName]       = ST.[Name]
			, [BuildCriteriaOrdinal]             = BC.[Ordinal]
			, [BuildCriteriaName]                = BC.[Name]
			, [OsatId]                           = C.[Osatid]
			, [OsatName]                         = O.[Name]
			, [DesignId]                         = C.[DesignId]
			, [DesignName]                       = D.[Name]
			, [DesignFamilyId]                   = D.[DesignFamilyId]
			, [DesignFamilyName]                 = DF.[Name]
			, [PackageDieTypeId]                 = C.[PackageDieTypeId]
			, [PackageDieTypeName]               = PDT.[Name]
			, [PackageDieTypeCount]              = PDT.[PackageDieCount]
			, [IntelLevel1PartNumber]            = C.[IntelLevel1PartNumber]
			, [IntelProdName]                    = C.[IntelProdName]
			, [MaterialMasterField]              = C.[MaterialMasterField]
			, [AssyUpi]                          = C.[AssyUpi]
			, [IsEngineeringSample]              = CASE PUT.[Id] WHEN 2 THEN 1 ELSE 0 END
			, [Device]                           = C.[DeviceName] + ISNULL(C.[Mpp], '')
			, [AttributeTypeName]                = T.[Name]
			, [AttributeValue]                   = BCC.[Value] + CASE BCC.[ComparisonOperationId] WHEN 6 THEN '+' ELSE '' END
		FROM [qan].[OsatBuildCriterias]                     AS BC  WITH (NOLOCK)
		LEFT OUTER JOIN [qan].[OsatBuildCriteriaSets]       AS S   WITH (NOLOCK) ON (S.[Id] = BC.[BuildCriteriaSetId])
		LEFT OUTER JOIN [qan].[OsatBuildCombinations]       AS C   WITH (NOLOCK) ON (C.[Id] = S.[BuildCombinationId])
	--	LEFT OUTER JOIN [qan].[OsatBuildCombinationOsats]   AS CO  WITH (NOLOCK) ON (CO.[BuildCombinationId] = C.[Id])
		LEFT OUTER JOIN [qan].[Osats]                       AS O   WITH (NOLOCK) ON (O.[Id] = C.[Osatid])
		LEFT OUTER JOIN [qan].[Products]                    AS D   WITH (NOLOCK) ON (D.[Id] = C.[DesignId])
		LEFT OUTER JOIN [ref].[DesignFamilies]              AS DF  WITH (NOLOCK) ON (DF.[Id] = D.[DesignFamilyId])
		LEFT OUTER JOIN [ref].[PartUseTypes]                AS PUT WITH (NOLOCK) ON (PUT.[Id] = C.[PartUseTypeId])
		LEFT OUTER JOIN [qan].[OsatPackageDieTypes]         AS PDT WITH (NOLOCK) ON (PDT.[Id] = C.[PackageDieTypeId])
		LEFT OUTER JOIN [qan].[OsatBuildCriteriaConditions] AS BCC WITH (NOLOCK) ON (BCC.[BuildCriteriaId] = BC.[Id])
		LEFT OUTER JOIN [qan].[OsatAttributeTypes]          AS T   WITH (NOLOCK) ON (T.[Id] = BCC.[AttributeTypeId])
		LEFT OUTER JOIN [ref].[Statuses]                    AS ST  WITH (NOLOCK) ON (ST.[Id] = S.[StatusId])
		WHERE
			    (@DesignId IS NULL OR C.[DesignId] = @DesignId)
			AND (@OsatId   IS NULL OR C.[Osatid]  = @OsatId)
			AND (@StatusId IS NULL OR S.[StatusId]  = @StatusId)
			AND (@VersionId IS NULL OR S.[Version]  = @VersionId)
			AND (@CreatedBy IS NULL OR S.[CreatedBy]  = @CreatedBy)
			AND (@IncludePublishDisabled = 1 OR C.[PublishDisabledOn] IS NULL)
			AND (
							(
								(@IsPOR IS NULL OR S.[IsPOR] = @IsPOR) 
								AND ISNULL(@IncludeStatusInReview, 0) =1
								AND ISNULL(@IncludeStatusSubmitted, 0)=1
								AND ISNULL(@IncludeStatusDraft, 0)=1
							)
							OR
							EXISTS(SELECT 1 FROM (
																	SELECT MAX(S2.Id) Id, [S2].[BuildCombinationId]
																	FROM [qan].[OsatBuildCriteriaSets] S2 
																	WHERE 
																						(ISNULL(@IncludeStatusInReview, 0)=1 AND S2.[StatusId]=5)
																						OR
																						(ISNULL(@IncludeStatusSubmitted, 0)=1 AND S2.[StatusId]=3)
																						OR
																						(ISNULL(@IncludeStatusDraft, 0)=1 AND S2.[StatusId]=1)
																						OR
																						S2.[StatusId]=6

																	GROUP BY  [S2].[BuildCombinationId]
																) T2
							WHERE [T2].[Id]=BC.[BuildCriteriaSetId] AND [T2].[BuildCombinationId]=[S].[BuildCombinationId])
					)
	) AS A PIVOT
		(
			MAX([AttributeValue]) FOR [AttributeTypeName] IN
				(
					  [apo_number]
					, [app_restriction]
					, [ate_tape_revision]
					, [burn_flow]
					, [burn_tape_revision]
					, [cell_revision]
					, [cmos_revision]
					, [country_of_assembly]
					, [custom_testing_reqd]
					, [fab_conv_id]
					, [fab_excr_id]
					, [fabrication_facility]
					, [lead_count]
					, [major_probe_prog_rev]
					, [marketing_speed]
					, [non_shippable]
					, [num_array_decks]
					, [num_flash_ce_pins]
					, [num_io_channels]
					, [pgtier]
					, [prb_conv_id]
					, [product_grade]
					, [reticle_wave_id]
				)
		) AS P
)