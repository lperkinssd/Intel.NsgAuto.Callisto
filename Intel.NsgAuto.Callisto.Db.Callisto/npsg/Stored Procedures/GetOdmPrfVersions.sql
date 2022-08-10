


-- ==================================================================================
-- Author		: jkurian
-- Create date	: 2021-02-11 16:03:23.837
-- Description	: Gets PRF versions 
--				EXEC [npsg].[GetOdmPrfVersions] 'jkurian'
-- ==================================================================================
CREATE PROCEDURE [npsg].[GetOdmPrfVersions]
(
	    @UserId VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT DISTINCT
		[PrfVersion] AS [Id],
		[PrfVersion] AS [VersionNumber],
		[CreatedBy],
		[CreatedOn]
	FROM [npsg].[PRFDCR]
	ORDER BY [PrfVersion] DESC

END