-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-06-17 17:49:47.020
-- Description  : Gets osat qual filter export and it's associated data
-- Example      : EXEC [qan].[GetOsatQualFilterExport] 'bricschx', 1;
-- =======================================================================
CREATE PROCEDURE [qan].[GetOsatQualFilterExport]
(
	  @UserId VARCHAR(25)
	, @Id     INT
)
AS
BEGIN
	SET NOCOUNT ON;

	-- @Id should always be populated; but just in case, set to an invalid value so filters below will not return any records
	IF (@Id IS NULL) SET @Id = 0;

	-- #1 result set: export
	SELECT * FROM [qan].[FOsatQualFilterExports](@Id);

	-- #2 result set: files
	SELECT * FROM [qan].[FOsatQualFilterExportFiles](NULL, @Id, NULL, NULL, NULL, NULL, NULL) ORDER BY [Id];

	-- #3 result set: records
	SELECT * FROM [qan].[OsatQualFilterExportFileRecords] WITH (NOLOCK) WHERE [ExportId] = @Id ORDER BY [Id];

END
