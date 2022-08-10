-- ============================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-30 11:52:41.753
-- Description  : Translates the customer name in speed to a system customer name
-- Example      : SELECT [qan].[TranslateSpeedCustomer]('ORCL');
-- ============================================================================================
CREATE FUNCTION [qan].[TranslateSpeedCustomer]
(
	  @Name VARCHAR(50)
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Result VARCHAR(50) = @Name;

	IF @Name = '0' SET @Result = 'Generic';
	ELSE IF @Name = 'AMZ' SET @Result = 'Amazon';
	ELSE IF @Name = 'APPL' SET @Result = 'Apple';
	ELSE IF @Name = 'FJTSU' SET @Result = 'Fujistu';
	ELSE IF @Name = 'HITC' SET @Result = 'Hitachi';
	ELSE IF @Name = 'LE' SET @Result = 'Lenovo';
	ELSE IF @Name = 'MSFT' SET @Result = 'Microsoft';
	ELSE IF @Name = 'NTAPP' SET @Result = 'NetApp';
	ELSE IF @Name = 'ORCL' SET @Result = 'Oracle';

	RETURN (@Result);
END