-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-30 15:08:46.330
-- Description  : Translates the attribute type name in treadstone to a system display name
-- Example      : SELECT [qan].[TranslateTreadstoneAttributeTypeNameDisplay]('app_restriction');
-- ================================================================================================
CREATE FUNCTION [qan].[TranslateTreadstoneAttributeTypeNameDisplay]
(
	  @Name VARCHAR(50)
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Result VARCHAR(50) = @Name;

	IF @Name = 'app_restriction' SET @Result = 'App Restriction';
	ELSE IF @Name = 'cell_revision' SET @Result = 'Cell Revision';
	ELSE IF @Name = 'cmos_revision' SET @Result = 'Cmos Revision';
	ELSE IF @Name = 'country_of_assembly' SET @Result = 'Country Of Assembly';
	ELSE IF @Name = 'fab_conv_id' SET @Result = 'Fab Conv Id';
	ELSE IF @Name = 'fab_excr_id' SET @Result = 'Fab Excr Id';
	ELSE IF @Name = 'major_probe_prog_rev' SET @Result = 'Major Probe Program Revision';
	ELSE IF @Name = 'mppr_first' SET @Result = 'Major Probe Program Revision First';
	ELSE IF @Name = 'offshore_asm_company' SET @Result = 'Offshore Asm Company';
	ELSE IF @Name = 'probe_ship_part_type' SET @Result = 'Probe Ship Part Type';
	ELSE IF @Name = 'product_grade' SET @Result = 'Product Grade';
	ELSE IF @Name = 'reticle_wave_id' SET @Result = 'Reticle Wave Id';
	ELSE IF @Name = 'trade_sale' SET @Result = 'Trade Sale';
	ELSE IF @Name = 'ts_state' SET @Result = 'TS State';

	RETURN (@Result);
END
