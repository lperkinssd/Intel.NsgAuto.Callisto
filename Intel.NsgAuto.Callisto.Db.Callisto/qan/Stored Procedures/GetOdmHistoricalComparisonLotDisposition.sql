
-- ==================================================================================================================================================
-- Author       : ftianx (modified based on [qan].[GetOdmComparisonLotDisposition])
-- Create date  : 2021-11-03 10:58:58.698
-- Description  : Get ODM Historical Comparison Lot Disposition
-- Example      : EXEC [qan].[GetOdmHistoricalComparisonLotDisposition] 'fuhantx', 15
-- ==================================================================================================================================================
CREATE PROCEDURE [qan].[GetOdmHistoricalComparisonLotDisposition] 
	@UserId VARCHAR(25), 
	@Id INT
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_NULLS ON;

	DECLARE @qualifiedCatagoryId INT = (SELECT Id FROM [Callisto].[ref].[OdmQualFilterCategories] WITH (NOLOCK) WHERE [Name] = 'Qualified')
	DECLARE @localId INT = @Id

	DECLARE @PrfVersion INT,
			@MatVersion INT,
			@OdmWipSnapshotVersion INT,
			@LotShipSnapshotVersion INT,
			@LotDispositionSnapshotVersion INT,
			@CreatedBy VARCHAR(25),
			@CreatedOn datetime2(7)

	SELECT
		 @PrfVersion = [PrfVersion]
		,@MatVersion = [MatVersion]
		,@OdmWipSnapshotVersion = [OdmWipSnapshotVersion]
		,@LotShipSnapshotVersion = [LotShipSnapshotVersion]
		,@LotDispositionSnapshotVersion = [LotDispositionSnapshotVersion]
		,@CreatedBy = [CreatedBy]
		,@CreatedOn = [CreatedOn]
	FROM [qan].[OdmQualFilterScenarios]
	WHERE [Id] = @localId

    IF OBJECT_ID('tempdb..#TargetOdmWipSnapshots') IS NOT NULL 
		DROP TABLE #TargetOdmWipSnapshots;

	CREATE TABLE #TargetOdmWipSnapshots(
		[media_lot_id] [varchar](255) NOT NULL,
		[subcon_name] [varchar](255) NOT NULL,
		[inventory_location] [varchar](255) NULL,
		[location_type] [varchar](255) NULL,
		[mm_number] [varchar](255) NULL,
		[category] [varchar](255) NULL,
		[time_entered] [datetime2](7) NULL
	);

	CREATE NONCLUSTERED INDEX IX_Temp_#TargetOdmWipSnapshots ON #TargetOdmWipSnapshots ([media_lot_id], [time_entered])

	-- A WipSnapShots version might be in both scenarios of current day and the day before
	IF ((SELECT COUNT(*) FROM [qan].[OdmWipSnapshots] WITH (NOLOCK) WHERE [Version] = @OdmWipSnapshotVersion) > 0)
	BEGIN
		INSERT INTO #TargetOdmWipSnapshots
		SELECT 
				[media_lot_id] [varchar],
				[subcon_name] [varchar],
				[inventory_location],
				[location_type] [varchar],
				[mm_number] [varchar],
				[category] [varchar],
				[time_entered]
		FROM [qan].[OdmWipSnapshots] WITH (NOLOCK) 
		WHERE [Version] = @OdmWipSnapshotVersion
	END
	ELSE
	BEGIN
		INSERT INTO #TargetOdmWipSnapshots
		SELECT 
				[media_lot_id] [varchar],
				[subcon_name] [varchar],
				[inventory_location],
				[location_type] [varchar],
				[mm_number] [varchar],
				[category] [varchar],
				[time_entered]
		FROM [qan].[OdmWipSnapshotsHistory] WITH (NOLOCK) 
		WHERE [Version] = @OdmWipSnapshotVersion
	END

    IF OBJECT_ID('tempdb..#TargetOdmLotShipSnapshots') IS NOT NULL 
		DROP TABLE #TargetOdmLotShipSnapshots;

	CREATE TABLE #TargetOdmLotShipSnapshots(
		[media_lot_id] [varchar](255) NOT NULL,
		[major_probe_prog_rev] [varchar](255) NULL,
		[burn_tape_revision] [varchar](255) NULL,
		[cell_revision] [varchar](50) NULL,
		[custom_testing_reqd] [varchar](50) NULL,
		[fab_conv_id] [varchar](50) NULL,
		[fab_excr_id] [varchar](255) NULL,
		[product_grade] [varchar](50) NULL,
		[reticle_wave_id] [varchar](50) NULL,
		[probe_program_rev] [varchar](255) NULL
	);

	CREATE NONCLUSTERED INDEX IX_Temp_TargetOdmLotShipSnapshots ON #TargetOdmLotShipSnapshots ([media_lot_id])

	-- A LotShipSnapShots version might be in both scenarios of current day and the day before
	IF ((SELECT COUNT(*) FROM [qan].[OdmLotShipSnapshots] WITH (NOLOCK) WHERE [Version] = @LotShipSnapshotVersion) > 0)
	BEGIN
		INSERT INTO #TargetOdmLotShipSnapshots
		SELECT 
				[media_lot_id],
				[major_probe_prog_rev],
				[burn_tape_revision],
				[cell_revision],
				[custom_testing_reqd],
				[fab_conv_id],
				[fab_excr_id],
				[product_grade],
				[reticle_wave_id] ,
				[probe_program_rev] 
		FROM [qan].[OdmLotShipSnapshots] WITH (NOLOCK) 
		WHERE [Version] = @LotShipSnapshotVersion
	END
	ELSE
	BEGIN
		INSERT INTO #TargetOdmLotShipSnapshots
		SELECT 
				[media_lot_id],
				[major_probe_prog_rev],
				[burn_tape_revision],
				[cell_revision],
				[custom_testing_reqd],
				[fab_conv_id],
				[fab_excr_id],
				[product_grade],
				[reticle_wave_id] ,
				[probe_program_rev] 
		FROM [qan].[OdmLotShipSnapshotsHistory] WITH (NOLOCK) 
		WHERE [Version] = @LotShipSnapshotVersion
	END

	IF OBJECT_ID('tempdb..#LatestSLotUpdateTimeStamps') IS NOT NULL  
		DROP TABLE #LatestSLotUpdateTimeStamps

	SELECT DISTINCT
		nqm.SLot, 
		MAX(ows.time_entered) AS [MaxTimeEntered]
	INTO #LatestSLotUpdateTimeStamps
	FROM [qan].[OdmQualFiltersHistory] nqm WITH (NOLOCK)
		INNER JOIN #TargetOdmWipSnapshots ows WITH (NOLOCK)
			ON nqm.SLot = ows.media_lot_id
	WHERE nqm.[ScenarioId] = @localId
	GROUP BY nqm.SLot;

	;WITH OdmLDDetails AS
	(
		SELECT DISTINCT
			  nqm.[Id]
			, m.SSD_ID as [SSD_Id]
			, ows.subcon_name AS [SubConName]
			, ows.inventory_location AS [InventoryLocation]
			, ows.mm_number AS [MMNumber]
			, ows.location_type AS [LocationType]
			, ows.category AS [Category]
			, nqm.SLot AS [SLot]
			, nqm.DesignId AS [DesignId]
			, m.Scode AS [SCode]
			, m.Media_IPN AS [MediaIPN]
			, m.Major_Probe_Program_Revision AS [PorMajorProbeProgramRevision]
			, lss.major_probe_prog_rev AS [ActualMajorProbeProgramRevision]
			, m.Burn_Tape_Revision AS [PorBurnTapeRevision]
			, lss.burn_tape_revision  AS [ActualBurnTapeRevision]
			, m.Cell_Revision AS [PorCellRevision]
			, lss.cell_revision AS [ActualCellRevision]
			, m.Custom_Testing_Required AS [PorCustomTestingRequired]
			, lss.custom_testing_reqd AS [ActualCustomTestingRequired]
			, m.Fab_Conv_Id AS [PorFabConvId]
			, lss.fab_conv_id AS [ActualFabConvId]
			, m.Fab_Excr_Id AS [PorFabExcrId]
			, lss.fab_excr_id AS [ActualFabExcrId]
			, m.Product_Grade AS [PorProductGrade]
			, lss.product_grade AS [ActualProductGrade]
			, m.Reticle_Wave_Id AS [PorReticleWaveId]
			, lss.reticle_wave_id AS [ActualReticleWaveId]
			, m.Fab_Facility AS [PorFabFacility]
			--, lss.fabrication_facility AS [ActualFabFacility]
			, ''  AS [ActualFabFacility]
			, m.Probe_Revision AS [PorProbeRev]
			, lss.probe_program_rev AS [ActualProbeRev]
			, ISNULL(ld.LotDispositionReasonId, 0) AS [LotDispositionReasonId]
			--, ldr.[Description] AS [LotDispositionReason]
			, (CASE WHEN ld.LotDispositionActionId IS NOT NULL THEN ld.Notes ELSE (CASE WHEN nqm.OdmQualFilterCategoryId = @qualifiedCatagoryId THEN 'Exception' ELSE '' END) END) AS [Notes]
			, ISNULL(ld.LotDispositionActionId, nqm.OdmQualFilterCategoryId ) AS [LotDispositionActionId]
			--, lda.ActionName AS [LotDispositionActionName]
			--, lda.DisplayText AS [LotDispositionDisplayText]
			, ld.UpdatedBy AS [UpdatedBy]
			, ld.UpdatedOn AS [UpdatedOn]
		FROM [qan].[OdmQualFiltersHistory] nqm WITH (NOLOCK)
			INNER JOIN #TargetOdmLotShipSnapshots lss WITH (NOLOCK)
				ON nqm.SLot = lss.media_lot_id
			INNER JOIN #TargetOdmWipSnapshots ows WITH (NOLOCK)
				ON nqm.SLot = ows.media_lot_id
			INNER JOIN [qan].[MAT] m WITH (NOLOCK)
				ON nqm.SCode = m.Scode
					AND nqm.MediaIPN = m.Media_IPN
			INNER JOIN #LatestSLotUpdateTimeStamps ts  WITH (NOLOCK)
				ON ows.media_lot_id = ts.SLot
				AND ows.time_entered = ts.MaxTimeEntered
			INNER JOIN [ref].[Odms] o  WITH (NOLOCK)
				ON nqm.[OdmId] = o.[Id]
				AND ows.[subcon_name] = o.[Name]
			LEFT JOIN [qan].[OdmQualFilterLotDispositionsHistory] ld  WITH (NOLOCK)
				ON nqm.Id = ld.OdmQualFilterId
		WHERE m.[MatVersion] = @MatVersion 
			AND nqm.[ScenarioId] = @localId
	)

	SELECT odldd.* 
		, ldr.[Description] AS [LotDispositionReason]
		, lda.ActionName AS [LotDispositionActionName]
		, lda.DisplayText AS [LotDispositionDisplayText]
	FROM OdmLDDetails odldd
		LEFT JOIN [ref].[OdmLotDispositionReasons] ldr  WITH (NOLOCK)
			ON odldd.LotDispositionReasonId = ldr.Id
		LEFT JOIN [ref].[OdmLotDispositionActions] lda  WITH (NOLOCK)
			ON odldd.LotDispositionActionId = lda.Id

END