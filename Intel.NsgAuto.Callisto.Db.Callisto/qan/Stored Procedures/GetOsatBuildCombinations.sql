-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-02-25 19:28:23.593
-- Description  : Gets osat build combinations
-- Example      : EXEC [qan].[GetOsatBuildCombinations] 'bricschx', 1;
-- =======================================================================
CREATE PROCEDURE [qan].[GetOsatBuildCombinations]
(
	  @UserId                     VARCHAR(25)
	, @DesignId                   INT         = NULL
	, @OsatId                     INT         = NULL
	, @PorBuildCriteriaSetExists  BIT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [qan].[FOsatBuildCombinations](NULL, @UserId, NULL, @DesignId, NULL, NULL, NULL, NULL, NULL, NULL)
		WHERE (@PorBuildCriteriaSetExists IS NULL OR (@PorBuildCriteriaSetExists = 0 AND [PorBuildCriteriaSetId] IS NULL) OR (@PorBuildCriteriaSetExists = 1 AND [PorBuildCriteriaSetId] IS NOT NULL)) 
		       AND (Osatid = @OsatId or @OsatId is Null)
		ORDER BY [IntelLevel1PartNumber], [IntelProdName], [MaterialMasterField], [IntelMaterialPn], [AssyUpi], [Id];

END
