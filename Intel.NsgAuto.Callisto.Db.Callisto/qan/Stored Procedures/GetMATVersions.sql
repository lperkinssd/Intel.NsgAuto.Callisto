


-- ==================================================================================
-- Author		: jakemurx
-- Create date	: 2020-09-09 14:06:50.162
-- Description	: Gets MAT versions possibly filtering
--                on Id and IsActive
--				EXEC [qan].[GetMATVersions] 'jakemurx', null, null
-- ==================================================================================
CREATE PROCEDURE [qan].[GetMATVersions]
(
	    @UserId VARCHAR(25)
	  , @Id INT = NULL
	  , @IsActive BIT = NULL
	  , @IsPOR BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		  v.[Id]
		, v.[VersionNumber]
		, v.[IsActive]
		, v.[StatusId]
		, LTRIM(RTRIM(s.[Name])) AS [Status]
		, v.[IsPOR]
		, LTRIM(RTRIM(v.[CreatedBy])) AS [CreatedBy]
		, v.[CreatedOn]
		, LTRIM(RTRIM(v.[UpdatedBy])) AS [UpdatedBy]
		, v.[UpdatedOn]
	FROM [qan].[MATVersions] v WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[Statuses] s WITH (NOLOCK) ON (v.[StatusId] = s.[Id])
	WHERE (@Id IS NULL OR v.[Id] = @Id) AND (@IsActive IS NULL OR v.[IsActive] = @IsActive) AND (@IsPOR IS NULL OR v.[IsPOR] = @IsPOR)
	ORDER BY v.[VersionNumber] DESC, v.[Id] DESC;
END