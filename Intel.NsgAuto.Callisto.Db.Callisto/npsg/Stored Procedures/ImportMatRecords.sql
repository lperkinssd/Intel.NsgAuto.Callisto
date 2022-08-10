



-- =============================================================
-- Author:		Neeraja
-- Create date: 2018-07-09 17:45:07.280
-- Description:	Creates MAT records
--				
-- =============================================================
CREATE PROCEDURE [npsg].[ImportMatRecords]
(
	  @UserId varchar(50)
    , @MatRecords [npsg].[IMatRecords] READONLY
)
AS

BEGIN
	SET NOCOUNT ON;
	BEGIN TRY					
		DECLARE @max_mat integer;
		DECLARE @designFamilyId INT;
		SELECT @designFamilyId = Id FROM [ref].[DesignFamilies] WITH (NOLOCK) WHERE Name = 'NAND';

		------ Merge users to the users table
		UPDATE [npsg].[MAT] SET Latest = 0;

		SELECT @max_mat = MAX([MatVersion]) from [npsg].[MAT];

		IF @max_mat is null 
			SET @max_mat = 1;
		ELSE
			SET @max_mat += 1;

		INSERT INTO [npsg].[MAT] (
		       [MatVersion],
			   [WW],
			   [SSD_Id],
			   [Design_Id],
			   [Scode],
			   [Cell_Revision], 
			   [Major_Probe_Program_Revision],
			   [Probe_Revision],
			   [Burn_Tape_Revision],
			   [Product_Grade],
			   [Custom_Testing_Required],
			   [Custom_Testing_Required2],
			   [Prb_Conv_Id],
			   [Fab_Conv_Id],
			   [Fab_Excr_Id],
			   [Media_Type],
			   [Media_IPN],
			   [Device_Name],
			   [Reticle_Wave_Id],
			   [Fab_Facility],
			   [Latest],
			   [FileType],
			   [CreatedOn],
			   [CreatedBy],
			   [UpdatedOn],
			   [UpdatedBy])
			SELECT
				@max_mat,
				[WW],
				[SSD_Id],
				[Design_Id],
				[Scode],
				[Cell_Revision],				
				[Major_Probe_Program_Revision],
				[Probe_Revision],
				[Burn_Tape_Revision],
				[Product_Grade],
				[Custom_Testing_Required],
				[Custom_Testing_Required2],
				[Prb_Conv_Id],
				[Fab_Conv_Id],
				[Fab_Excr_Id],
				[Media_Type],
				[Media_IPN],
				[Device_Name],
				[Reticle_Wave_Id],
				[Fab_Facility],
				1,
				'P',
				GETDATE(),
				@UserId,
				GETDATE(),
				@UserId
			FROM @MatRecords mt
			JOIN [qan].[Products] pt WITH (NOLOCK)
				ON mt.Design_Id = pt.Name
				AND pt.DesignFamilyId = @designFamilyId
				AND pt.IsActive = 1
	END TRY
	BEGIN CATCH
	END CATCH	
END