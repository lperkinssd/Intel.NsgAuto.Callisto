-- =============================================
-- Author:		jakemurx
-- Create date: 2021-02-12 11:21:50.743
-- Description:	Get ODM Mat version detials
-- EXEC [npsg].[GetOdmMatVersionDetails] 'jakemurx', 1
-- =============================================
CREATE PROCEDURE [npsg].[GetOdmMatVersionDetails] 
	-- Add the parameters for the stored procedure here
	  @UserId     VARCHAR(25)
	, @Version    INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [MatVersion] AS [VersionId]
		  ,[WW]
		  ,[SSD_Id]
		  ,[Design_Id]
		  ,[Scode]
		  ,[Cell_Revision]
		  ,[Major_Probe_Program_Revision]
		  ,[Probe_Revision]
		  ,[Burn_Tape_Revision]
		  ,[Custom_Testing_Required]
		  ,[Custom_Testing_Required2]
		  ,[Product_Grade]
		  ,[Prb_Conv_Id]
		  ,[Fab_Conv_Id]
		  ,[Fab_Excr_Id]
		  ,[Media_Type]
		  ,[Media_IPN]
		  ,[Device_Name]
		  ,[Reticle_Wave_Id]
		  ,[Fab_Facility]
		  ,[Latest]
		  ,[FileType]
		  ,[CreatedBy]
		  ,[CreatedOn]
		  ,[UpdatedBy]
		  ,[UpdatedOn]
	  FROM [npsg].[MAT]
	  WHERE [MatVersion] = @Version
END