



-- =============================================================
-- Author:		jkurian
-- Create date: 2018-07-09 17:45:07.280
-- Description:	Creates PRFDCR records
--				
-- =============================================================
CREATE PROCEDURE [qan].[ImportPrfRecords]
(
	  @UserId varchar(255)
    , @PrfRecords [qan].[IPrfRecords] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY					
		DECLARE @PrfVersion INT = (SELECT MAX([PrfVersion]) FROM [qan].[PRFDCR] WITH (NOLOCK)) ;

		IF @PrfVersion IS NULL 
			SET @PrfVersion = 1;
		ELSE
			SET @PrfVersion = @PrfVersion + 1;

		INSERT INTO [qan].[PRFDCR]
           ([PrfVersion]
           ,[Odm_Desc]
           ,[SSD_Family_Name]
           ,[MM_Number]
           ,[Product_Code]
           ,[SSD_Name]
           ,[CreatedOn]
           ,[CreatedBy]
           ,[UpdatedOn]
           ,[UpdatedBy])
			SELECT
				@PrfVersion,
				UPPER([Odm_Desc]) AS [Odm_Desc],
				[SSD_Family_Name],
				[MM_Number],
				[Product_Code],
				[SSD_Name],
				GETDATE(),
				@UserId,
				GETDATE(),
				@UserId
			FROM @PrfRecords;
	END TRY
	BEGIN CATCH
		-- 
		--ROLLBACK TRAN;
		--SET @ErrorMessage = ERROR_MESSAGE();
		--SET @ErrorSeverity = ERROR_SEVERITY();
		--SET @ErrorState = ERROR_STATE();
		--RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH	
	

END