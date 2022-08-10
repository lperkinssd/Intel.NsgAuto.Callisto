-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-30 17:14:46.510
-- Description  : Updates all osat build criterias associated with a qual filter import to POR
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatQualFilterImportPorReturnDetails] NULL, @Message OUTPUT, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid id: 0'
-- ===============================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatQualFilterImportPorReturnDetails]
(
	  @Succeeded  BIT          OUTPUT
	, @Message    VARCHAR(500) OUTPUT
	, @UserId     VARCHAR(25)
	, @Id         INT
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[UpdateOsatQualFilterImportPor] @Succeeded OUTPUT, @Message OUTPUT, @UserId, @Id;

	-- #1 through #3 result sets
	EXEC [qan].[GetOsatQualFilterImportDetails] @UserId, @Id;

END
