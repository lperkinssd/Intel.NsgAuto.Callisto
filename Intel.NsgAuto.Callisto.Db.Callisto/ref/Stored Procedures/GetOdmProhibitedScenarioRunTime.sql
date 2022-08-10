
-- ==================================================================================================================================================
-- Author       : ftianx
-- Create date  : 2022-01-25 13:45:03.288
-- Description  : Get Odm Prohibited Scenario Run Time Range for  Nand
-- Example      : EXEC [ref].[GetOdmProhibitedScenarioRunTime] 'ftianx' 
-- ==================================================================================================================================================
CREATE PROCEDURE [ref].[GetOdmProhibitedScenarioRunTime]
(
	@userId VARCHAR(50),
	@process VARCHAR(10)
)
AS
BEGIN
	SET NOCOUNT ON;

   

		SELECT 
			[StartTime]
			,[EndTime]
		FROM [ref].[OdmProhibitedScenarioRunTime] WITH (NOLOCK) 
		WHERE [IsActive] = 1
		AND [Process] = @process
END