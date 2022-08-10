-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-11 14:05:11.350
-- Description  : Performs an OSAT PAS version import and returns the version
-- ======================================================================================
CREATE PROCEDURE [qan].[ImportOsatPasVersionReturnVersion]
(
	  @Succeeded          BIT          OUTPUT
	, @Message            VARCHAR(500) OUTPUT
	, @UserId             VARCHAR(25)
	, @OsatId             INT
	, @DesignFamilyId     INT
	, @OriginalFileName   VARCHAR(250)
	, @FileLengthInBytes  INT
	, @Records  [qan].[IOsatPasVersionRecordsImport] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Id INT = NULL;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[ImportOsatPasVersion] @Id OUTPUT, @Message OUTPUT, @UserId, @OsatId, @DesignFamilyId, @OriginalFileName, @FileLengthInBytes, @Records;

	IF (@Id IS NOT NULL) SET @Succeeded = 1;

	-- #1 result set: version
	SELECT * FROM [qan].[FOsatPasVersions](@Id, @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

END
