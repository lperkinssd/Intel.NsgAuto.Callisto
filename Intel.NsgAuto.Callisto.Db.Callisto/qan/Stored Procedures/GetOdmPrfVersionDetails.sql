

-- =============================================
-- Author:		jakemurx
-- Create date: 2021-02-12 11:21:50.743
-- Description:	Get ODM Prf version detials
-- EXEC [qan].[GetOdmPrfVersionDetails] 'jakemurx', 1
-- =============================================
CREATE PROCEDURE [qan].[GetOdmPrfVersionDetails] 
	-- Add the parameters for the stored procedure here
	  @UserId     VARCHAR(25)
	, @VersionId    INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		  
    -- Insert statements for procedure here
	SELECT [PrfVersion] AS [VersionId]
		  ,[Odm_Desc]
		  ,[SSD_Family_Name]
		  ,[MM_Number]
		  ,[Product_Code]
		  ,[SSD_Name]
		  ,[CreatedOn]
		  ,[CreatedBy]
		  ,[UpdatedOn]
		  ,[UpdatedBy]
	  FROM [qan].[PRFDCR]
	  WHERE [PrfVersion] = @VersionId
END