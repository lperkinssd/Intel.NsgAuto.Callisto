


-- ==================================================================================================================================================
-- Author       : ftianx
-- Create date  : 2022-03-08 12:58:28.108
-- Description  : Clear and archive NPSG ODM Manual Disposition data to its history table
-- Example      : DECLARE @userId VARCHAR(50) = 'system';
--                
--                EXEC [npsg].[ClearArchiveOdmManualDisposition] @userId 
 -- ==================================================================================================================================================
CREATE PROCEDURE [npsg].[ClearArchiveOdmManualDisposition]
(
	@userId VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

		BEGIN TRAN OdmManualHistory
		
		-- Archive and clear OdmManualDispositions
		INSERT INTO [npsg].[OdmManualDispositionsHistory]
		SELECT *, GETDATE(), @userId 
		FROM [npsg].[OdmManualDispositions] WITH (NOLOCK)

		DELETE FROM [npsg].[OdmManualDispositions] 

		COMMIT TRAN OdmManualHistory
	END TRY
	BEGIN CATCH		
		DECLARE @errorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @errorSeverity INT = ERROR_SEVERITY();
		DECLARE @errorState INT = ERROR_STATE();
		DECLARE @errorLine INT = ERROR_LINE();

		SET @errorMessage = @errorMessage + ' occurred at line ' + CAST(@errorLine AS NVARCHAR(50)) ;

		ROLLBACK TRAN OdmManualHistory
		RAISERROR (@errorMessage, @errorSeverity, @errorState);
	END CATCH;

END