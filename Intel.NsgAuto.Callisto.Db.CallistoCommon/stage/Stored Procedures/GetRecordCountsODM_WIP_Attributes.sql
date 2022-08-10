-- =============================================
-- Author:		jakemurx
-- Create date: 2020-09-16 12:47:14.880
-- Description:	Get record counts between odm_wip... tables
--              EXEC [stage].[GetRecordCountsODM_WIP_Attributes]
-- =============================================
CREATE PROCEDURE [stage].[GetRecordCountsODM_WIP_Attributes] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT COUNT(*) AS [Current]
	FROM [stage].[odm_wip_attributes_daily_load] WITH (NOLOCK)

	SELECT COUNT(*) AS [Previous]
	FROM [stage].[odm_wip_attributes_daily_load_Previous] WITH (NOLOCK)

END