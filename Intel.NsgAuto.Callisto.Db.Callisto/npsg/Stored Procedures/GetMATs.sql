


-- =========================================================================
-- Author		: jakemurx
-- Create date	: 2020-09-09 14:23:31.861
-- Description	: Gets MATs possibly filtering on Id and VersionId
--					EXEC [npsg].[GetMATs] 'jakemurx', null, 1, 1
-- =========================================================================
CREATE PROCEDURE [npsg].[GetMATs]
(
	    @UserId varchar(25)
	  , @Id int
	  , @VersionId int
	  , @IncludeAttributes bit
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		  m.[Id]
		, m.[MATVersionId]
		, v.[VersionNumber]
		, m.[SSDNameId]
		, LTRIM(RTRIM(ssd.[Name])) AS [SSDId]
		, p.[Id] AS [ProductId]
		, LTRIM(RTRIM(p.[Name])) AS [DesignId]
		--, pf.[Id] AS [ProductFamilyId]
		--, pf.[Name] AS [ProductFamilyName]
		, LTRIM(RTRIM(m.[SCode])) AS [SCode]
		, LTRIM(RTRIM(m.[MediaIPN])) AS [MediaIPN]
		, LTRIM(RTRIM(m.[MediaType])) AS [MediaType]
		, LTRIM(RTRIM(m.[DeviceName])) AS [DeviceName]
		, LTRIM(RTRIM(m.[CreatedBy])) AS [CreatedBy]
		, m.[CreatedOn]
		, LTRIM(RTRIM(m.[UpdatedBy])) AS [UpdatedBy]
		, m.[UpdatedOn]
	FROM [npsg].[MATs] m WITH (NOLOCK)
	LEFT JOIN [npsg].[MATVersions] v
		ON m.[MATVersionId] = v.[Id]
	LEFT JOIN [npsg].[MATSSDNames] ssd WITH (NOLOCK)
		ON m.[SSDNameId] = ssd.[Id]
	LEFT JOIN [npsg].[Products] p WITH (NOLOCK)
		ON m.[ProductId] = p.[Id]
	WHERE (@Id IS NULL OR m.[Id] = @Id) AND (@VersionId IS NULL OR m.[MATVersionId] = @VersionId)
	ORDER BY m.[Id];

	IF @IncludeAttributes > 0
	BEGIN
		EXEC [npsg].[GetMATAttributes] @UserId, null, @Id, @VersionId
	END

END