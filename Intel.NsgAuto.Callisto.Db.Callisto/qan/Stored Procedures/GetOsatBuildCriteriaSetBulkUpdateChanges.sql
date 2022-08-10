CREATE PROCEDURE [qan].[GetOsatBuildCriteriaSetBulkUpdateChanges] (
@BuildCriteriaSetId [BIGINT],
@ImportId INT
)
AS
BEGIN
  SET NOCOUNT ON;

  SELECT
    [IR].[Id],
    [IR].[Version],
    [IR].[BuildCombinationId],
    [IR].[BuildCriteriaSetId],
    [IR].[Attribute],
    [IR].[NewValue],
    [IR].[OldValue],
    [IR].[BuildCriteriaOrdinal]
  FROM
    [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords] IR
  WHERE
    [IR].[BuildCriteriaSetId] = @BuildCriteriaSetId
		AND [IR].[ImportId]=@ImportId;


END; 