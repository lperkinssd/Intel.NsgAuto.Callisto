-- ====================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-30 18:11:27.337
-- Description  : Cancels all osat build criterias associated with a qual filter import
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatQualFilterImportCanceledReturnDetails] NULL, @Message OUTPUT, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid id: 0'
-- ====================================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatQualFilterImportCanceledReturnDetails]
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

	EXEC [qan].[UpdateOsatQualFilterImportCanceled] @Succeeded OUTPUT, @Message OUTPUT, @UserId, @Id;

	-- #1 through #3 result sets
	EXEC [qan].[GetOsatQualFilterImportDetails] @UserId, @Id;

END
