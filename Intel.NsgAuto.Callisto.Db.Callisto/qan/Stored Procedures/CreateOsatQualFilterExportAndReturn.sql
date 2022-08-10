-- ==================================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-08 14:45:37.170
-- Description  : Creates a new auto checker qual filter export. After execution, if the output parameter @Succeeded = 0, then the export was not
--                created and @Message contains the reason.
-- Example      : DECLARE @Succeeded  BIT;
--                DECLARE @Message    VARCHAR(500);
--                DECLARE @DesignIds  [qan].[IInts];
--                DECLARE @OsatIds    [qan].[IInts];
--                EXEC [qan].[CreateOsatQualFilterExportAndReturn] @Succeeded OUTPUT, @Message OUTPUT, 'bricschx', @DesignIds, @OsatIds, 0;
--                PRINT 'Succeeded = ' + ISNULL(CAST(@Succeeded AS VARCHAR(20)), 'null') + '; Message = ' + ISNULL(@Message, 'null');
--                -- should print: Succeeded = 0; Message = There is no associated data to export
-- ==================================================================================================================================================
CREATE PROCEDURE [qan].[CreateOsatQualFilterExportAndReturn]
(
	  @Succeeded      BIT                  OUTPUT
	, @Message        VARCHAR(500)         OUTPUT
	, @UserId         VARCHAR(25)
	, @DesignIds      [qan].[IInts]        READONLY
	, @OsatIds        [qan].[IInts]        READONLY
	, @Comprehensive  BIT           = 1
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Id INT;

	SET @Succeeded = 0;
	SET @Message   = NULL;

	EXEC [qan].[CreateOsatQualFilterExport] @Id OUTPUT, @Message OUTPUT, @UserId, @DesignIds, @OsatIds, @Comprehensive;

	IF (@Id IS NOT NULL)
	BEGIN
		SET @Succeeded = 1;

		EXEC [qan].[GetOsatQualFilterExport] @UserId, @Id;
	END;

END
