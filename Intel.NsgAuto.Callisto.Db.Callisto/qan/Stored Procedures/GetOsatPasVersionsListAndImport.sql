-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-02-19 16:38:12.920
-- Description  : Gets OSAT PAS versions for the list and import view
-- Example      : EXEC [qan].[GetOsatPasVersionsListAndImport] 'bricschx';
-- ============================================================================
CREATE PROCEDURE [qan].[GetOsatPasVersionsListAndImport]
(
	  @UserId VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Process Varchar(MAX);    
	SET @Process = (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK)     
				INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId); 

	-- #1 result set: versions
	SELECT * FROM [qan].[FOsatPasVersions](NULL, @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL) 
	WHERE [CombinationDesignFamilyName] = @Process
	ORDER BY [Id] DESC;

	-- #2 result set: osats
	SELECT * FROM [qan].[Osats] WITH (NOLOCK) ORDER BY [Name];

	-- #3 result set: design families
	SELECT * FROM [qan].[FDesignFamilies](NULL, NULL, @UserId) ORDER BY [Name];

END
