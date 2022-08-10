-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-17 16:27:33.953
-- Description  : Executes all setup CreateInitial* procedures
-- Example      : EXEC [setup].[CreateAllInitial] 'bricschx', 'dev';
-- =================================================================================
CREATE PROCEDURE [setup].[CreateAllInitial]
(
	  @By           VARCHAR(25) = NULL
	, @Environment  VARCHAR(5)  = 'prod'
)
AS
BEGIN
	SET NOCOUNT ON;

	EXEC [setup].[CreateAllInitialReview] @By, @Environment;
	EXEC [setup].[CreateInitialAcBuildCriteriaTemplates] @By;
	EXEC [setup].[CreateInitialOsatAttributeTypes] @By;
	EXEC [setup].[CreateInitialOsatBuildCriteriaSetTemplates] @By;
	EXEC [setup].[CreateInitialOsatPackageDieTypes] @By;
	EXEC [setup].[CreateInitialOsats] @By;

END
