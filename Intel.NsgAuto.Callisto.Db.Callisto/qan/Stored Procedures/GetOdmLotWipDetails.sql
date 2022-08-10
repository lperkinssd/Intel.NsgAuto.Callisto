


-- =============================================
-- Author		: jkurian
-- Create date	: 2021-07-07 11:52:00.750
-- Description	: Get WIP details for an S-Lot from Treadstone database and 
--				  display the details in the UI
-- EXEC [qan].[GetOdmLotWipDetails]  'S051E22I', NULL, NULL, NULL, 'jkurian'
-- =============================================
CREATE PROCEDURE [qan].[GetOdmLotWipDetails] (
	  @SLot			VARCHAR(25)
	, @MediaIPN     VARCHAR(25)
	, @SCode		VARCHAR(25)
	, @OdmName		VARCHAR(25)
	, @UserId		VARCHAR(25)
	)
AS
BEGIN
	SELECT
		  wip.media_lot_id			AS SLot
		, wip.subcon_name			AS OdmName
		, wip.intel_part_number		AS MediaIPN
		, wip.location_type			AS LocationType
		, wip.inventory_location	AS [Location]
		, wip.category				AS Category
		, wip.mm_number				AS MMNumber
		, wip.time_entered			AS TimeEntered
	FROM [TREADSTONEPRD].[treadstone].[odm].[vw_callisto_odm_wip_data] wip
	WHERE 
		wip.media_lot_id = @SLot
		ORDER BY time_entered DESC;

END