


-- =============================================================
-- Author		:	jkurian
-- Create date	:	2021-07-29 13:45:25.217
-- Description	:	Importing & creating manual disposition records
-- =============================================================
CREATE PROCEDURE [npsg].[ImportOdmManualDispositions]
(
	  @UserId varchar(255)
    , @OdmManualDispositions [npsg].[IOdmManualDispositions] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @UserIdSid varchar(255) = @UserId;

	BEGIN TRY					
		-- Get the last version of the manual dispsotions import
		--DECLARE @LastOdmManualDispositionVersion integer = (SELECT ISNULL(MAX([Version]),0) FROM [npsg].[OdmManualDispositions] WITH (NOLOCK) );
		DECLARE @LastOdmManualDispositionVersion integer = (SELECT MAX([Version]) FROM [npsg].[OdmManualDispositions] WITH (NOLOCK) );
		
		IF @LastOdmManualDispositionVersion IS NULL
		BEGIN
			SET @LastOdmManualDispositionVersion = (SELECT ISNULL(MAX([Version]),0) FROM [npsg].[OdmManualDispositionsHistory] WITH (NOLOCK) );
		END

		-- Increment the version number
		DECLARE @NewOdmManualDispositionVersion integer = @LastOdmManualDispositionVersion + 1;
		-- Insert all the disposition records in coming into the table
		INSERT INTO [npsg].[OdmManualDispositions]
           ( [Version]
           , [SLot]
		   , [IntelPartNumber]
           , [LotDispositionReasonId]
           , [Notes]
           , [LotDispositionActionId]
           , [CreatedOn]
           , [CreatedBy]
           , [UpdatedOn]
           , [UpdatedBy])
			SELECT
				  @NewOdmManualDispositionVersion
				, [SLot]
				, [IntelPartNumber]
				, [LotDispositionReasonId]
				, [Notes]
				, [LotDispositionActionId]
				, GETDATE()
				, @UserIdSid
				, GETDATE()
				, @UserIdSid
			FROM @OdmManualDispositions;

	END TRY
	BEGIN CATCH
		--ROLLBACK TRAN;
		--SET @ErrorMessage = ERROR_MESSAGE();
		--SET @ErrorSeverity = ERROR_SEVERITY();
		--SET @ErrorState = ERROR_STATE();
		--RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH	
	
	-- Return any data that we need to return to the UI
	EXEC [npsg].[GetOdmManualDispositionsByVersion] @NewOdmManualDispositionVersion, @UserIdSid;
	
	-- Return the version information to the UI
	EXEC [npsg].[GetOdmManualDispositionsVersions] @UserIdSid;

END