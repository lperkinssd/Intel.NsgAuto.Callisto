



-- ==================================================================================
-- Author		: jkurian
-- Create date	: 2020-09-09 14:06:50.162
-- Description	: Gets ODM 
--				EXEC [qan].[GetODMQualFilterExplanations] 'jkurian'
-- ==================================================================================
CREATE PROCEDURE [qan].[GetODMQualFilterExplanations]
(
	    @UserId VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- This lots are excluded from the Disquailified list as the BTR is invalid
	SELECT 
		MediaLotid AS BadSLots 
	FROM [TREADSTONE].[treadstone].[qan].BadDataList WITH (NOLOCK);

	-- TO DO: First get the non qualified slots
	SELECT DISTINCT 
		qfr.s_lot, 
		MAX(owadl.time_entered) AS [MaxTimeEntered]
	INTO #LatestSLotUpdateTimeStamps
	FROM [TREADSTONE].[treadstone].[qan].[QualFilterRaw] qfr WITH (NOLOCK)
		INNER JOIN [TREADSTONE].[treadstone].[odm].[vw_callisto_odm_wip_data] owadl WITH (NOLOCK)
					ON qfr.s_lot = owadl.media_lot_id
	GROUP BY qfr.s_lot;

	------ TO DOO: Then get the latest ODM WIP for those slots & then join

	--  Side by Side comparison of POR and Actual attribute values for each disqualified lot.
	SELECT DISTINCT
		  owadl.subcon_name AS [SubConName]
		, m.SSD_ID as SSD_Id
		, owadl.inventory_location AS [InventoryLocation]
		, owadl.mm_number AS [MMNumber]
		, owadl.location_type AS [LocationType]
		, owadl.category AS [Category]
		, qfr.s_lot AS [SLot]
		, m.Scode AS [SCode]
		, m.Media_IPN AS [MediaIPN]
		, m.Major_Probe_Program_Revision AS [PorMajorProbeProgramRevision]
		, ls.major_probe_prog_rev AS [ActualMajorProbeProgramRevision]
		, m.Burn_Tape_Revision AS PorBurnTapeRevision
		, ls.burn_tape_revision  AS ActualBurnTapeRevision 
		, m.Cell_Revision AS PorCellRevision
		, ls.cell_revision AS ActualCellRevision 
		, m.Custom_Testing_Required AS PorCustomTestingRequired
		, ls.custom_testing_reqd AS ActualCustomTestingRequired
		, m.Fab_Conv_Id AS PorFabConvId
		, ls.fab_conv_id AS ActualFabConvId
		, m.Fab_Excr_Id AS PorFabExcrId
		, ls.fab_excr_id AS ActualFabExcrId 
		, m.Product_Grade AS PorProductGrade
		, ls.product_grade AS ActualProductGrade
		, m.Reticle_Wave_Id AS PorReticleWaveId
		, ls.reticle_wave_id AS ActualReticleWaveId 
		, m.Fab_Facility AS PorFabFacility 
		, ls.fabrication_facility AS ActualFabFacility
		, m.Probe_Revision  as PORProbeRev
		, ls.probe_program_rev as ACTProbeRev
	FROM [TREADSTONE].[treadstone].[qan].[QualFilterRaw] qfr WITH (NOLOCK)
			INNER JOIN [TREADSTONE].[treadstone].[dbo].[lot_ship] ls WITH (NOLOCK)
				ON qfr.s_lot = ls.lot_id
			INNER JOIN [TREADSTONE].[treadstone].[odm].[vw_callisto_odm_wip_data] owadl WITH (NOLOCK)
				ON qfr.s_lot = owadl.media_lot_id
			INNER JOIN [TREADSTONE].[treadstone].[qan].[MAT] m WITH (NOLOCK)
				ON qfr.ScodeMm = m.Scode
					AND qfr.MediaIpn = m.Media_IPN
			INNER JOIN #LatestSLotUpdateTimeStamps ts
				ON owadl.time_entered = ts.MaxTimeEntered
	WHERE m.Latest = 'Y' 
		--AND owadl.time_entered = (SELECT 
		--			MAX(e.time_entered) 
		--		FROM [TREADSTONEPRD].[treadstone].[odm].[odm_wip_attributes_daily_load] e WITH (NOLOCK) 
		--		WHERE e.media_lot_id = qfr.s_lot)
	ORDER BY owadl.subcon_name ASC, qfr.s_lot ASC, m.SCode ASC;

		------ Side by Side comparison of POR and Actual attribute values for each disqualified lot.
		----select distinct D.subcon_name, D.inventory_location, B.s_lot SLot, A.Scode SCode, A.Media_IPN MediaIpn,
		----A.Major_Probe_Program_Revision PORMPPR, C.major_probe_prog_rev ACTMPPR, 
		----A.Burn_Tape_Revision PORBTR, C.burn_tape_revision ACTBTR, 
		----A.Cell_Revision PORCellRev, C.cell_revision ActCellRev, 
		----A.Custom_Testing_Required PORCTR, C.custom_testing_reqd ACTCTR,
		----A.Fab_Conv_Id PORFabConvId, C.fab_conv_id ActFabConvId,
		----A.Fab_Excr_Id PORFabExcrId, C.fab_excr_id ActFabExcrid, 
		----A.Product_Grade PORProdGrade, C.product_grade ActProdGrade
		----,A.Reticle_Wave_Id PORRetId, C.reticle_wave_id ActRetid, 
		----A.Fab_Facility PORFab, C.fabrication_facility ActFab		
		----from qan.MAT A , qan.QualFilterRaw B, dbo.lot_ship C , odm.odm_wip_attributes_daily_load D
		----where
		----A.Latest = 'Y' 
		----and A.Scode = B.ScodeMm 
		----and A.Media_IPN = B.MediaIpn
		----and B.s_lot = C.lot_id 
		----and B.s_lot = D.media_lot_id
		----and D.time_entered = (select max(e.time_entered) from odm.odm_wip_attributes_daily_load e where e.media_lot_id = B.s_lot)
		----order by subcon_name, S_lot, Scode


END