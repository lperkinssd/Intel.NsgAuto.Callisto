
-- =============================================
-- Author:		jakemurx
-- Create date: 2021-02-24 14:08:36.027
-- Description:	Create the [qan].[OdmWipSnapshots] entries by comparing [qan].[odm_wip_attributes_daily_load_staging] to [qan].[OdmWipSnapshots]
-- =============================================
CREATE PROCEDURE [qan].[CreateOdmWipSnapshot]
	-- Add the parameters for the stored procedure here
	  @CountInserted INT = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Count INT;
	DECLARE @Version INT = (SELECT Top 1 [Version] FROM [qan].[OdmWipSnapshots] ORDER BY [Version] DESC);
	IF @Version IS NULL
		SET @Version = 0;

    -- Insert statements for procedure here
	TRUNCATE TABLE [qan].[odm_wip_attributes_daily_load_staging];

	INSERT INTO [qan].[odm_wip_attributes_daily_load_staging]
	SELECT * FROM [CallistoCommon].[stage].[odm_wip_attributes_daily_load] WITH (NOLOCK)

	IF OBJECT_ID('tempdb..#odm_wip') IS NOT NULL  DROP TABLE #odm_wip;

	CREATE TABLE #odm_wip(
		[media_lot_id] [varchar](255) NOT NULL,
		[subcon_name] [varchar](255) NOT NULL,
		[intel_part_number] [varchar](255) NULL,
		[location_type] [varchar](255) NULL,
		[inventory_location] [varchar](255) NULL,
		[category] [varchar](255) NULL,
		[mm_number] [varchar](255) NULL,
		[time_entered] [datetime2](7) NULL
	)

	INSERT INTO #odm_wip
	SELECT [media_lot_id]
		,[subcon_name]
		,[intel_part_number]
		,[location_type]
		,[inventory_location]
		,[category]
		,[mm_number]
		,[time_entered]
	FROM  [qan].[odm_wip_attributes_daily_load_staging] WITH (NOLOCK)
	EXCEPT
	SELECT [media_lot_id]
      ,[subcon_name]
      ,[intel_part_number]
      ,[location_type]
      ,[inventory_location]
      ,[category]
      ,[mm_number]
      ,[time_entered]
	FROM [qan].[OdmWipSnapshots] WITH (NOLOCK)
	WHERE [Version] = @Version

	SELECT @Count = COUNT(*) FROM #odm_wip;

	IF @Count > 0
	BEGIN
		-- Get the next Version number
		SET @Version = @Version + 1;
		-- Copy [qan].[OdmWipSnapshots] to archive
		-- Truncate [qan].[OdmWipSnapshots]
		-- Insert [qan].[odm_wip_attributes_daily_load_staging] to [qan].[OdmWipSnapshots] with new version number
		INSERT INTO [qan].[OdmWipSnapshots]
		SELECT @Version
			,[media_lot_id]
			,[subcon_name]
			,[intel_part_number]
			,[location_type]
			,[inventory_location]
			,[category]
			,[mm_number]
			,[time_entered]
		FROM  [qan].[odm_wip_attributes_daily_load_staging] WITH (NOLOCK)

		SELECT @CountInserted = COUNT(*) FROM [qan].[odm_wip_attributes_daily_load_staging];
	END

END