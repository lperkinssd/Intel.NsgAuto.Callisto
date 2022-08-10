-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-02-25 15:01:55.550
-- Description  : Gets all data needed for the osat design summary view
-- Example      : EXEC [qan].[GetOsatDesignSummary] 'bricschx', 1;
-- =======================================================================
CREATE PROCEDURE [qan].[GetOsatDesignSummary]
(
	  @UserId    VARCHAR(25)
	, @DesignId  INT         = NULL
	, @DesignFamilyId INT	 = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	-- record set #1: designs
	SELECT * FROM [qan].[FProducts](NULL, @UserId, NULL, @DesignFamilyId, NULL, NULL) ORDER BY [Name];
	
	-- record set #2: valid osat build combinations
	SELECT * FROM [qan].[FOsatBuildCombinations](NULL, @UserId, 1, @DesignId, NULL, NULL, NULL, NULL, NULL, NULL)
	WHERE (@DesignFamilyId IS NULL OR [DesignFamilyId] = @DesignFamilyId)
	ORDER BY [IntelLevel1PartNumber], [IntelProdName], [MaterialMasterField], [IntelMaterialPn], [AssyUpi], [Id];

	SELECT * FROM [qan].Osats ORDER BY [Name]

END
