-- ===========================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-28 18:36:13.200
-- Description  : Gets all data needed for viewing the details for an osat qual filter import
-- Example      : EXEC [qan].[GetOsatQualFilterImportDetails] 'bricschx', 1;
-- ===========================================================================================
CREATE PROCEDURE [qan].[GetOsatQualFilterImportDetails]
(
	  @UserId     VARCHAR(25)
	, @Id         INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	-- set to non-existant id so filters below will not return any data
	IF (@Id IS NULL) SET @Id = 0;

	-- #1 result set: import record
	SELECT * FROM [qan].[FOsatQualFilterImports](@UserId, @Id);

	-- #2 result set: import build criterias
	SELECT * FROM [qan].[FOsatQualFilterImportBuildCriterias](NULL, @Id, NULL, NULL) ORDER BY [GroupIndex], [CriteriaIndex], [Id] ASC;

	-- #3 result set: messages
	SELECT * FROM [qan].[FOsatQualFilterImportMessages](NULL, @Id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [MessageType] ASC, [GroupIndex] ASC, [CriteriaIndex] ASC, [GroupFieldIndex] ASC, [Id] ASC;

END
