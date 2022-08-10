-- =============================================
-- Author:		jakemurx
-- Create date: now
-- Description:	Get Odm Qual Filter Non Qualified Media Report
-- EXEC [npsg].[GetOdmQualFilterNonQualifiedMediaReport] 'jakemurx', 1
-- =============================================
CREATE PROCEDURE [npsg].[GetOdmQualFilterNonQualifiedMediaReport] 
	-- Add the parameters for the stored procedure here
	@UserId varchar(25), 
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [ScenarioId]
		  ,[MMNum]
		  ,[OdmName]
		  ,[DesignId]
		  ,[SLots]
		  ,[MatId]
		  ,[PrfId]
		  ,[OsatIpn]
		  ,[CreatedBy]
		  ,[CreatedOn]
	  FROM [npsg].[OdmQualFilterNonQualifiedMediaReport]
	  WHERE [ScenarioId] = @Id
END