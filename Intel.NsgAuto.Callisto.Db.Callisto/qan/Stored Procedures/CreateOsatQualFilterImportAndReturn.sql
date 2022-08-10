-- ===========================================================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-24 13:50:11.907
-- Description  : Creates a new auto checker qual filter import. After execution, if the output parameter @Succeeded is null, then the import was not
--                created and @Message contains the reason.
-- Example      : DECLARE @Succeeded   INT;
--                DECLARE @Message     VARCHAR(500);
--                DECLARE @Groups      [qan].[IOsatQfImportGroups];
--                DECLARE @GroupFields [qan].[IOsatQfImportGroupFields];
--                DECLARE @Criterias   [qan].[IOsatQfImportCriterias];
--                DECLARE @Attributes  [qan].[IOsatQfImportAttributes];
--                EXEC [qan].[CreateOsatQualFilterImportAndReturn] @Id OUTPUT, @Message OUTPUT, 'bricschx', 'test.xlsx', 0, @Groups, @GroupFields, @Criterias, @Attributes;
--                PRINT 'Succeeded = ' + ISNULL(CAST(@Succeeded AS VARCHAR(20)), 'null') + '; Message = ' + ISNULL(@Message, 'null');
--                -- should print: Id = null; Message = No criteria data could be determined
-- ===========================================================================================================================================================================
CREATE PROCEDURE [qan].[CreateOsatQualFilterImportAndReturn]
(
	  @Succeeded          BIT                  OUTPUT
	, @Message            VARCHAR(500)         OUTPUT
	, @UserId             VARCHAR(25)
	, @FileName           VARCHAR(250)
	, @FileLengthInBytes  INT
	, @Groups             [qan].[IOsatQfImportGroups]      READONLY
	, @GroupFields        [qan].[IOsatQfImportGroupFields] READONLY
	, @Criterias          [qan].[IOsatQfImportCriterias]   READONLY
	, @Attributes         [qan].[IOsatQfImportAttributes]  READONLY
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Id      INT;
	DECLARE @UserId2 VARCHAR(25) = [qan].[FixSystemUserId](@UserId);

	SET @Succeeded = 0;
	SET @Message   = NULL;

	EXEC [qan].[CreateOsatQualFilterImport] @Id OUTPUT, @Message OUTPUT, @UserId, @FileName, @FileLengthInBytes, @Groups, @GroupFields, @Criterias, @Attributes;

	IF (@Id IS NOT NULL)
	BEGIN
		SET @Succeeded = 1;

		SELECT * FROM [qan].[FOsatQualFilterImports](@UserId2, @Id);
	END;

END
