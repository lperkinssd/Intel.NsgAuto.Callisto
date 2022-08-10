-- =============================================
-- Author:		jakemurx
-- Create date: 2021-03-03 11:17:08.350
-- Description:	Get ODM Comparison Lot Disposition
-- EXEC [npsg].[GetOdmComparisonLotDisposition] 'jakemurx', 84
-- =============================================
CREATE PROCEDURE [npsg].[GetOdmComparisonLotDisposition] 
	-- Add the parameters for the stored procedure here
	@UserId varchar(25), 
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @qualifiedCatagoryId INT = (SELECT Id FROM [Callisto].[ref].[OdmQualFilterCategories] WITH (NOLOCK) WHERE [Name] = 'Qualified')
	DECLARE @localId INT = @Id

    -- Insert statements for procedure here
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
	FROM [npsg].[OdmQualFilterScenarios]
	WHERE [Id] = @localId

	IF OBJECT_ID('tempdb..#LatestSLotUpdateTimeStamps') IS NOT NULL  DROP TABLE #LatestSLotUpdateTimeStamps

	SELECT DISTINCT
		nqm.SLot, 
		MAX(ows.time_entered) AS [MaxTimeEntered]
	INTO #LatestSLotUpdateTimeStamps
	FROM [npsg].[OdmQualFilters] nqm WITH (NOLOCK)
		INNER JOIN [npsg].[OdmWipSnapshots] ows WITH (NOLOCK)
			ON nqm.SLot = ows.media_lot_id
	WHERE nqm.[ScenarioId] = @localId
	AND ows.[Version] = @OdmWipSnapshotVersion
	GROUP BY nqm.SLot;

	CREATE NONCLUSTERED INDEX IX_Temp_#LatestSLotUpdateTimeStamps ON #LatestSLotUpdateTimeStamps ([SLot], [MaxTimeEntered])

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
		FROM [npsg].[OdmQualFilters] nqm WITH (NOLOCK)
			INNER JOIN [npsg].[OdmLotShipSnapshots] lss WITH (NOLOCK)
				ON nqm.SLot = lss.media_lot_id
			INNER JOIN [npsg].[OdmWipSnapshots] ows WITH (NOLOCK)
				ON nqm.SLot = ows.media_lot_id
			INNER JOIN [npsg].[MAT] m WITH (NOLOCK)
				ON nqm.SCode = m.Scode
					AND nqm.MediaIPN = m.Media_IPN
			INNER JOIN #LatestSLotUpdateTimeStamps ts  WITH (NOLOCK)
				ON ows.media_lot_id = ts.SLot
				AND ows.time_entered = ts.MaxTimeEntered
			INNER JOIN [ref].[Odms] o  WITH (NOLOCK)
				ON nqm.[OdmId] = o.[Id]
				AND ows.[subcon_name] = o.[Name]
			LEFT JOIN [npsg].[OdmQualFilterLotDispositions] ld  WITH (NOLOCK)
				ON nqm.Id = ld.OdmQualFilterId
		WHERE m.[MatVersion] = @MatVersion 
			AND nqm.[ScenarioId] = @localId		
			AND ows.[Version] = @OdmWipSnapshotVersion
			AND lss.[Version] = @LotShipSnapshotVersion
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