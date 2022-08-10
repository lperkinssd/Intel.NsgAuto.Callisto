-- =============================================================
-- Author		: jakemurx
-- Create date	: 2020-09-14 16:11:32.630
-- Description	: Copy the latest work week records from stage.MAT to stage.MAT_Archive
--              : before the newest qan.MAT records from Treadstone are copied over to MAT
--                   EXEC [stage].[UpdateMAT_Archive] 33
-- =============================================================
CREATE PROCEDURE [stage].[UpdateMAT_Archive]
	-- Add the parameters for the stored procedure here
	@MAT_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [stage].[MAT_Archive]
	SELECT [MAT_Id]
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
		  ,[Create_Date]
		  ,[User]
		  ,[Latest]
		  ,[File_Type]
	  FROM [stage].[MAT]
	  WHERE [MAT_Id] = @MAT_Id
	  ORDER BY [MAT_Id]
END