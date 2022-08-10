

-- ===================================================
-- Author       : ftianx
-- Create date  : 2022-03-15 09:21:35.080
-- Description  : Create the Odm Prohibited Scenario Run Times
-- Example      : EXEC [setup].[CreateOdmProhibitedScenarioRunTimes];
--                SELECT * FROM [ref].[OdmProhibitedScenarioRunTime];
-- ===================================================
CREATE PROCEDURE [setup].[CreateOdmProhibitedScenarioRunTimes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[OdmProhibitedScenarioRunTime]';
	BEGIN
		TRUNCATE TABLE [ref].[OdmProhibitedScenarioRunTime];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[OdmProhibitedScenarioRunTime] ON;

		INSERT INTO [ref].[OdmProhibitedScenarioRunTime]
				   ([Id]
				   ,[Process]
				   ,[StartTime]
				   ,[EndTime]
				   ,[IsActive]
				   ,[EffectiveDate]
				   ,[DeactivatedDate])
		VALUES
			 (3, 'NAND', '9:45AM','10:45AM', 1, GETDATE(), NULL)
			, (4, 'NAND', '2:45AM','3:45AM', 1, GETDATE(), NULL);

		SET IDENTITY_INSERT [ref].[OdmProhibitedScenarioRunTime] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[OdmProhibitedScenarioRunTime] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR);
	PRINT @Message;
END