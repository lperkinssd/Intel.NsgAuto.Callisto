-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-23 11:41:33.077
-- Description  : Creates the initial osat attribute types
-- Example      : EXEC [setup].[CreateInitialOsatAttributeTypes] 'bricschx';
--                SELECT * FROM [qan].[OsatAttributeTypes];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateInitialOsatAttributeTypes]
(
	  @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[qan].[OsatAttributeTypes]';
	IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	MERGE [qan].[OsatAttributeTypes] AS M
	USING
	(VALUES
		  ('apo_number', 'APO Number', 1)
		, ('app_restriction', 'App Restriction', 1)
		, ('ate_tape_revision', 'Ate Tape Revision', 2)
		, ('burn_flow', 'Burn Flow', 1)
		, ('burn_tape_revision', 'Burn Tape Revision', 2)
		, ('cell_revision', 'Cell Revision', 2)
		, ('cmos_revision', 'Cmos Revision', 1)
		, ('country_of_assembly', 'Country Of Assembly', 1)
		, ('custom_testing_reqd', 'Custom Testing Required', 1)
		, ('fab_conv_id', 'Fab Conversion Id', 1)
		, ('fab_excr_id', 'Fab Excr Id', 1)
		, ('fabrication_facility', 'Fabrication Facility', 1)
		, ('lead_count', 'Lead Count', 2)
		, ('major_probe_prog_rev', 'Major Probe Program Revision', 2)
		, ('marketing_speed', 'Marketing Speed', 2)
		, ('non_shippable', 'Non-Shippable', 1)
		, ('num_array_decks', 'Number Of Array Decks', 2)
		, ('num_flash_ce_pins', 'Number Of Flash CE Pins', 2)
		, ('num_io_channels', 'Number Of IO Channels', 2)
		, ('pgtier', 'PG Tier', 1)
		, ('prb_conv_id', 'Probe Conversion Id', 1)
		, ('product_grade', 'Product Grade', 1)
		, ('reticle_wave_id', 'Reticle Wave Id', 1)
	) AS N ([Name], [NameDisplay], [DataTypeId])
	ON (M.[Name] = N.[Name])
	WHEN NOT MATCHED THEN INSERT ([Name], [NameDisplay], [DataTypeId], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], N.[NameDisplay], N.[DataTypeId], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @Count = COUNT(*) FROM @Ids;
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
