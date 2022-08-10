
-- =============================================
-- Author:		jakemurx
-- Create date: 2020-09-16 12:50:14.746
-- Description:	Get record counts between lot_ship tables
--              EXEC [stage].[GetRecordCountsLotShip] 
-- =============================================
CREATE PROCEDURE [stage].[GetRecordCountsLotShip] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT COUNT(*) AS [Current]
	FROM [stage].[lot_ship]

	SELECT COUNT(*) AS [Previous]
	FROM [stage].[lot_ship_Previous]

END