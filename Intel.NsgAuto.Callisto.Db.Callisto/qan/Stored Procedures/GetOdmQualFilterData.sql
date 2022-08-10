-- =============================================
-- Author:		jakemurx
-- Create date: 2021-03-02 10:23:18.283
-- Description:	Get Odm Qual Filter Data
-- EXEC [qan].[GetOdmQualFilterData] 'jakemurx'
-- =============================================
CREATE PROCEDURE [qan].[GetOdmQualFilterData] 
	-- Add the parameters for the stored procedure here
	@UserId VARCHAR(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [MMNum]
		  ,[OdmName]
		  ,[DesignId]
		  ,[SLots]
		  ,[MatId]
		  ,[PrfId]
		  ,[OsatIpn]
		  ,[CreatedBy]
		  ,[CreateOn]
	  FROM [qan].[OdmQualFilterStaging]
END