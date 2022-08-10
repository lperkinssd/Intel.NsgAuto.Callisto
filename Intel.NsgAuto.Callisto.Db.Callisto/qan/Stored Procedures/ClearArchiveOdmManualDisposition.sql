



-- ==================================================================================================================================================
-- Author       : ftianx
-- Create date  : 2022-03-08 12:58:28.108
-- Description  : Clear and archive IOG ODM Manual Disposition data to its history table
-- Example      : DECLARE @userId VARCHAR(50) = 'system';
--                
--                EXEC [qan].[ClearArchiveOdmManualDisposition] @userId 
 -- ==================================================================================================================================================
CREATE PROCEDURE [qan].[ClearArchiveOdmManualDisposition]
(
	@userId VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

		BEGIN TRAN OdmManualHistory
		
		-- Archive and clear OdmManualDispositions
		INSERT INTO [qan].[OdmManualDispositionsHistory]
		SELECT *, GETDATE(), @userId 
		FROM [qan].[OdmManualDispositions] WITH (NOLOCK)

		DELETE FROM [qan].[OdmManualDispositions] 

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