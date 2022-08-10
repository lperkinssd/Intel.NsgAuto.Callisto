-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-04-21 14:42:56.850
-- Description  : Gets all data required for the osat qual filter view
-- Example      : EXEC [qan].[GetOsatQualFilter] 'bricschx', 1;
-- =======================================================================
CREATE PROCEDURE [qan].[GetOsatQualFilter]
(
	  @UserId    VARCHAR(25)
	, @DesignId  INT         = NULL
	, @OsatId    INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	-- result set #1: designs
	SELECT * FROM [qan].[FProducts](NULL, @UserId, NULL, NULL, NULL, NULL) ORDER BY [Name];

	-- result set #2: osats
	SELECT * FROM [qan].[Osats] WITH (NOLOCK) ORDER BY [Name];

	-- result set #3: qual filter records
	SELECT * FROM [qan].[FOsatQualFilterRecords](@DesignId, @OsatId, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [OsatId], [DesignId], [PackageDieTypeName], [BuildCriteriaSetId], [BuildCriteriaOrdinal];

END
