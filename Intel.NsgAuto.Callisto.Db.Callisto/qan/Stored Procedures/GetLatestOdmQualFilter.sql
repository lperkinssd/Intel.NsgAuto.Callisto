-- =============================================
-- Author:		jakemurx
-- Create date: 2021-02-18 08:29:21.957
-- Description:	Get latest ODM Qual Filter data
-- exec [qan].[GetLatestOdmQualFilter] 
-- =============================================
CREATE PROCEDURE [qan].[GetLatestOdmQualFilter] 
	-- Add the parameters for the stored procedure here
	  @UserId VARCHAR(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [QUALID], [MMNum], UPPER([OdmName]) AS [OdmName], [DesignId], [SLots], [MatId], [PrfId], [OsatIpn], [CreateDate], [UserId] 
	FROM [qan].[ODMQUALFILTER] WITH (NOLOCK) 
	WHERE [Latest] = 'Y'   
	ORDER BY [OdmName], [OsatIpn];
END