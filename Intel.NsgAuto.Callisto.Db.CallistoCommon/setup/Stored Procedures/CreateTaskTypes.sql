
-- ===================================================
-- Author       : bricschx
-- Create date  : 2020-10-02 09:21:37.060
-- Description  : Creates the task types
-- Example      : EXEC [setup].[CreateTaskTypes];
--                SELECT * FROM [ref].[TaskTypes];
-- ===================================================
CREATE PROCEDURE [setup].[CreateTaskTypes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[TaskTypes]';
	BEGIN
		TRUNCATE TABLE [ref].[TaskTypes];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[TaskTypes] ON;

		INSERT [ref].[TaskTypes] ([Id], [Name], [ThresholdTimeLimit], [CodeLocation])
		VALUES
			  (1,  'Template', 5, '[CallistoCommon].[stage].[TaskTemplate]')
			, (2,  'Speed Pull', 60, '[CallistoCommon].[stage].[TaskSpeedPull]')
			, (3,  'Speed Import', 5, '[Callisto].[qan].[TaskSpeedImport]')
			, (4,  'Speed Data Transform', 10, '[CallistoCommon].[stage].[TaskSpeedDataTransform]')
			, (5,  'Create MM Recipes', 10, '[Callisto].[qan].[TaskCreateMMRecipes]')
			, (6,  'Speed MM Recipe Data', 10, '[CallistoCommon].[stage].[TaskSpeedMMRecipeData]')
			, (7,  'Sync Treadstone Auto Checker Build Criterias', 5, '[Callisto].[qan].[TaskSyncTreadstoneAcBuildCriterias]')
			, (8,  'Sync Treadstone Auto Checker Attribute Data', 5, '[Callisto].[qan].[TaskSyncTreadstoneAcAttributeData]')
			, (9,  'Treadstone Pull Lot Ship', 30, '[CallistoCommon].[stage].[TaskTreadstonePullLotShip]')
			, (10, 'Treadstone Pull ODM WIP', 30, '[CallistoCommon].[stage].[TaskTreadstonePullOdmWip]')
			, (11, 'Treadstone Snapshots', 30, '[Callisto].[qan].[TaskTreadstoneSnapshots]')
			, (12, 'Osat Qual Filter Export', 10, 'Intel.NsgAuto.Callisto.Business.Applications.OsatQualFilterExportApplication')
			, (13, 'Create ODM QF Snapshots And Scenario', 30, '[Callisto].[qan].[TaskCreateOdmQualFilterSnapshotsAndScenario]')
			, (14, 'Create ODM QF WIP Snapshot', 15, '[Callisto].[qan].[TaskCreateOdmQualFilterWipSnapshot]')
			, (15, 'Create ODM QF Lot Ship Snapshot', 20, '[Callisto].[qan].[TaskCreateOdmQualFilterLotShipSnapshot]')
			, (16, 'Create ODM QF Scenario', 10, '[Callisto].[qan].[TaskCreateOdmQualFilterScenario]')
			, (17, 'Treadstone Pull MAT', 10, '[CallistoCommon].[stage].[TaskTreadstonePullMat]')
			, (18, 'Treadstone Pull PRF', 10, '[CallistoCommon].[stage].[TaskTreadstonePullPrf]')
			, (19, 'Osat Qual Filter Import', 10, 'Intel.NsgAuto.Callisto.Business.Applications.OsatQualFilterImportApplication')
			, (20, 'Create ODM QF Historical WIP BOH Snapshot', 20, '[Callisto].[qan].[TaskCreateOdmQualFilterHistoricalWipBohSnapshot]')
			, (21, 'Create ODM QF NPSG Snapshots And Scenario', 30, '[Callisto].[npsg].[TaskCreateOdmQualFilterSnapshotsAndScenario]')
			, (22, 'Create ODM QF NPSG WIP Snapshot', 15, '[Callisto].[npsg].[TaskCreateOdmQualFilterWipSnapshot]')
			, (23, 'Create ODM QF NPSG Lot Ship Snapshot', 20, '[Callisto].[npsg].[TaskCreateOdmQualFilterLotShipSnapshot]')
			, (24, 'Create ODM QF NPSG Scenario', 10, '[Callisto].[npsg].[TaskCreateOdmQualFilterScenario]')	
			, (25, 'Create ODM QF NPSG Historical WIP BOH Snapshot', 20, '[Callisto].[npsg].[TaskCreateOdmQualFilterHistoricalWipBohSnapshot]')
			, (26, 'Archive IOG ODM QF Scenario', 20, '[Callisto].[qan].[TaskArchiveOdmQualFilterScenario]')
			, (27, 'Archive NPSG ODM QF Scenario', 20, '[Callisto].[npsg].[TaskArchiveOdmQualFilterScenario]')
			, (28, 'Process IOG Removable SLots', 20, '[CallistoCommon].[stage].[TaskProcessIOGRemovableSLots]')
			, (29, 'Process NPSG Removable SLots', 20, '[CallistoCommon].[stage].[TaskProcessNPSGRemovableSLots]')	
			, (30, 'Create ODM QF Snapshots And Scenario DownloadOnly', 30, '[Callisto].[qan].[TaskCreateOdmQualFilterSnapshotsAndScenarioDownloadOnly]')
			, (31, 'Create ODM QF NPSG Snapshots And Scenario DownloadOnly', 30, '[Callisto].[npsg].[TaskCreateOdmQualFilterSnapshotsAndScenarioDownloadOnly]');

		SET IDENTITY_INSERT [ref].[TaskTypes] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[TaskTypes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR);
	PRINT @Message;
END
