


-- ==================================================================================================================================================
-- Author       : ftianx
-- Create date  : 2021-10-25 12:58:28.108
-- Description  : Archive IOG ODM QF Scenario data to history tables
-- Example      : DECLARE @userId VARCHAR(50) = 'system';
--                
--                EXEC [qan].[TaskArchiveOdmQualFilterScenario] @userId 
 -- ==================================================================================================================================================
CREATE PROCEDURE [qan].[TaskArchiveOdmQualFilterScenario]
(
	@userId VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @taskId BIGINT;

	BEGIN TRY
		EXEC [CallistoCommon].[stage].[CreateTaskByName] @taskId OUTPUT, 'Archive IOG ODM QF Scenario';

		DECLARE @latestScenarioId INT
		DECLARE @largestScenarioIdToArchive INT
		DECLARE @latestScenarioCreatedOn DATETIME2(7)
		DECLARE @latestScenarioDate DATETIME2(7)

		SELECT @latestScenarioId = MAX(Id) FROM [qan].[OdmQualFilterScenarios] WITH (NOLOCK)
		IF @latestScenarioId IS NULL RETURN

		SELECT @latestScenarioCreatedOn = CreatedOn FROM [qan].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE Id = @latestScenarioId
		SET @latestScenarioDate = DATEADD(DD, DATEDIFF(DD, 0, @latestScenarioCreatedOn), 0)
		SELECT @largestScenarioIdToArchive = MIN(Id) FROM [qan].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE [CreatedOn] >= @latestScenarioDate
		IF @largestScenarioIdToArchive IS NULL RETURN

		DECLARE @largestOdmWipSnapshotVersionToArchive INT
				, @largestLotShipSnapshotVersionToArchive INT
				, @largestOdmWipSnapshotVersion INT
				, @largestLotShipSnapshotVersion INT

		SELECT @largestOdmWipSnapshotVersionToArchive = [OdmWipSnapshotVersion]
				,@largestLotShipSnapshotVersionToArchive = [LotShipSnapshotVersion]
		FROM [qan].[OdmQualFilterScenarios] WITH (NOLOCK)
		WHERE [Id] = @largestScenarioIdToArchive

		BEGIN TRAN OdmHistory

		-- Archive OdmWipSnapshots
		INSERT INTO [qan].[OdmWipSnapshotsHistory]
		SELECT *, GETDATE(), @userId FROM [qan].[OdmWipSnapshots] WITH (NOLOCK)
		WHERE Version < @largestOdmWipSnapshotVersionToArchive

		DELETE FROM [qan].[OdmWipSnapshots] 
		WHERE Version < @largestOdmWipSnapshotVersionToArchive

		-- Archive OdmLotShipSnapshots
		INSERT INTO [qan].[OdmLotShipSnapshotsHistory]
		SELECT *, GETDATE(), @userId FROM [qan].[OdmLotShipSnapshots] WITH (NOLOCK)
		WHERE Version < @largestLotShipSnapshotVersionToArchive

		DELETE FROM [qan].[OdmLotShipSnapshots] 
		WHERE Version < @largestLotShipSnapshotVersionToArchive
		
		-- Archive OdmQualFilters
		INSERT INTO [qan].[OdmQualFiltersHistory]
		SELECT *, GETDATE(), @userId FROM [qan].[OdmQualFilters] WITH (NOLOCK)
		WHERE ScenarioId < @largestScenarioIdToArchive

		DELETE FROM [qan].[OdmQualFilters] 
		WHERE ScenarioId < @largestScenarioIdToArchive

		-- Archive OdmQualFilterLotDispositions
		INSERT INTO [qan].[OdmQualFilterLotDispositionsHistory]
		SELECT *, GETDATE(), @userId FROM [qan].[OdmQualFilterLotDispositions] WITH (NOLOCK)
		WHERE ScenarioId < @largestScenarioIdToArchive

		DELETE FROM [qan].[OdmQualFilterLotDispositions] 
		WHERE ScenarioId < @largestScenarioIdToArchive

		COMMIT TRAN OdmHistory
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
				SET @errorMessage = @errorMessage + ' occurred at line ' + CAST(@errorLine AS NVARCHAR(50)) ;
				EXEC [CallistoCommon].[stage].[UpdateTaskAbort] @taskId;
				EXEC [CallistoCommon].[stage].[CreateTaskMessage] @taskId, 'Abort', @errorMessage;
			END TRY
			BEGIN CATCH
			END CATCH;
		END;

		ROLLBACK TRAN OdmHistory
		RAISERROR (@errorMessage, @errorSeverity, @errorState);
	END CATCH;

END