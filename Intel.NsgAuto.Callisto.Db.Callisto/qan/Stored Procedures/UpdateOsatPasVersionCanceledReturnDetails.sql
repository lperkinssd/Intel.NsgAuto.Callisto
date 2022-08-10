-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-29 17:52:46.007
-- Description  : Cancels an OSAT PAS version and returns all data needed for the details view
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatPasVersionCanceledReturnDetails] NULL, @Message OUTPUT, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid version: 0'
-- ===============================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatPasVersionCanceledReturnDetails]
(
	  @Succeeded  BIT          OUTPUT
	, @Message    VARCHAR(500) OUTPUT
	, @UserId     VARCHAR(25)
	, @Id         INT
	, @Override   BIT    = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[UpdateOsatPasVersionCanceled] @Succeeded OUTPUT, @Message OUTPUT, @UserId, @Id, @Override;

	-- #1 and #2 result sets
	EXEC [qan].[GetOsatPasVersionDetails] @UserId, @Id;

END
