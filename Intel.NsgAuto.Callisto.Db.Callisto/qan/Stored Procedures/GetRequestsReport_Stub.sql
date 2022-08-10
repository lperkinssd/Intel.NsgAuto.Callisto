
-- =============================================
-- Author:		jakemurx
-- Create date: 2020-09-30 14:25:04.916
-- Description:	Get requests report
-- =============================================
CREATE PROCEDURE [qan].[GetRequestsReport_Stub] 
	-- Add the parameters for the stored procedure here
	@p1 int = 0, 
	@p2 int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @p1, @p2
END