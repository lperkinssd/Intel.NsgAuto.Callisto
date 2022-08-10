CREATE PROCEDURE [qan].[GetOsatBuildCriteriaSetBulkImportDesignAndVersion]
	@Id int
AS
BEGIN

		SELECT TOP 1 [Version], [DesignId] 
		FROM [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords]
		WHERE [ImportId]=@Id

END