
-- =============================================================
-- Author       : ftianx
-- Create date  : 2021-11-15 16:38:00.313
-- Description  : Process IOG Removable SLots
-- Example      : DECLARE @userId varchar(50);
--                
-- =============================================================
CREATE PROCEDURE [stage].[TaskProcessIOGRemovableSLots]
(
	  @userId varchar(50)
    , @removableSLots [stage].[IOdmRemovableSLots] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @taskId BIGINT;

	BEGIN TRY
		EXEC [CallistoCommon].[stage].[CreateTaskByName] @taskId OUTPUT, 'Process IOG Removable SLots';

		DECLARE @newVer INT
		DECLARE @curVer INT = (SELECT MAX(Version) FROM [stage].[OdmIOGRemovableSLots] WITH (NOLOCK))

		IF @curVer IS NULL
			SET @newVer = 1
		ELSE
			SET @newVer = @curVer + 1

		BEGIN TRAN RemovingSLotsTran

		IF @newVer > 1
		BEGIN
			INSERT INTO [stage].[OdmIOGRemovableSLotsHistory]
			SELECT *, GETDATE(), @userId FROM [stage].[OdmIOGRemovableSLots] WITH (NOLOCK)
			
			DELETE FROM [stage].[OdmIOGRemovableSLots]
		END

		INSERT INTO [stage].[OdmIOGRemovableSLots]
           ([Version]
           ,[MMNum]
           ,[DesignId]
           ,[MediaIPN]
           ,[SLot]
           ,[CreateDate]
           ,[IsRemovable]
           ,[OdmName]
           ,[SourceFileName]
           ,[ReportedOn]
           ,[ReportedBy])
		SELECT 
			@newVer
           ,[MMNum]
           ,[DesignId]
           ,[MediaIPN]
           ,[SLot]
           ,[CreateDate]
           ,[IsRemovable]
           ,[OdmName]
           ,[SourceFileName]
           ,GETDATE()
		   , @userId
		FROM @removableSLots

		-- Update Callisto db
		;WITH RemovableSLots AS 
		(
			SELECT DISTINCT
			   od.Id AS OdmId
			   ,ors.[MMNum]
			   ,ors.[DesignId]
			   ,ors.[MediaIPN]
			   ,ors.[SLot]
			   ,ors.[CreateDate]
			   ,ors.[IsRemovable]
			FROM [stage].[OdmIOGRemovableSLots] ors WITH (NOLOCK)
				JOIN [Callisto].[ref].[Odms] od WITH (NOLOCK)
					ON UPPER(ors.OdmName) = od.Name
			WHERE UPPER([IsRemovable]) = 'YES'
		)

		MERGE [Callisto].[qan].[OdmQualFilterRemovableMedia] AS TRG
		USING RemovableSLots AS SRC
		ON
		(
				--TRG.[MMNum]		= SRC.[MMNum]		AND
				--TRG.[DesignId]	= SRC.[DesignId]	AND
				TRG.[MediaIPN]	= SRC.[MediaIPN]	AND
				TRG.[SLot]		= SRC.[SLot]			
		)
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT
				([RemovableVersion]
				,[OdmId]
				,[MMNum]
				,[DesignId]
				,[MediaIPN]
				,[SLot]
				,[OdmCreateDate]
				,[ReportedOn]
				,[ReportedBy])
			VALUES
				(@newVer
				,SRC.[OdmId]
				,SRC.[MMNum]
				,SRC.[DesignId]
				,SRC.[MediaIPN]
				,SRC.[SLot]
				,SRC.[CreateDate]
				,GETDATE()
				, @userId
				);

		COMMIT TRAN RemovingSLotsTran
		EXEC [CallistoCommon].[stage].[UpdateTaskEnd] @taskId;
	END TRY
	BEGIN CATCH		
		DECLARE @errorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @errorSeverity INT = ERROR_SEVERITY();
		DECLARE @errorState INT = ERROR_STATE();
		DECLARE @errorLine INT = ERROR_LINE();

		IF @taskId IS NOT NULL
		BEGIN
			BEGIN TRY
				SET @errorMessage = @errorMessage + ' occurred in [stage].[TaskProcessIOGRemovableSLots] at line ' + CAST(@errorLine AS NVARCHAR(50)) ;
				EXEC [CallistoCommon].[stage].[UpdateTaskAbort] @taskId;
				EXEC [CallistoCommon].[stage].[CreateTaskMessage] @taskId, 'Abort', @errorMessage;
			END TRY
			BEGIN CATCH
			END CATCH;
		END;

		ROLLBACK TRAN RemovingSLotsTran
		RAISERROR (@errorMessage, @errorSeverity, @errorState);
	END CATCH;
END