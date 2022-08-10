-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-29 16:33:47.670
-- Description  : Gets all data needed for viewing the details for an OSAT PAS version
-- Example      : EXEC [qan].[GetOsatPasVersionDetails] 'bricschx', 1;
-- ======================================================================================
CREATE PROCEDURE [qan].[GetOsatPasVersionDetails]
(
	  @UserId     VARCHAR(25)
	, @Id         INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	-- #1 result set: version
	SELECT * FROM [qan].[FOsatPasVersions](@Id, @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

	-- #2 result set: version records
	SELECT * FROM [qan].[FOsatPasVersionRecords](NULL, @Id, NULL) ORDER BY [RecordNumber], [Id] ASC;

	-- #3 result set: import messages
	SELECT * FROM [qan].[FOsatPasVersionImportMessages](NULL, @Id, NULL, NULL, NULL) ORDER BY [MessageType] ASC, [RecordNumber] ASC, [FieldName] ASC, [Id] ASC;

END
