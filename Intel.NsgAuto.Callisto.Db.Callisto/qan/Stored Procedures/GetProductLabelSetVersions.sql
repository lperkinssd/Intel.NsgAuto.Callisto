-- ==================================================================================
-- Author       : bricschx
-- Create date  : 2020-08-21 16:19:44.183
-- Description  : Gets product label versions
-- Example      : EXEC [qan].[GetProductLabelSetVersions] 'bricschx', 1
-- ==================================================================================
CREATE PROCEDURE [qan].[GetProductLabelSetVersions]
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
		  V.[Id]
		, V.[Version]
		, V.[IsActive]
		, V.[IsPOR]
		, V.[StatusId] AS [StatusId]
		, S.[Name] AS [StatusName]
		, V.[CreatedBy]
		, V.[CreatedOn]
		, V.[UpdatedBy]
		, V.[UpdatedOn]
	FROM [qan].[ProductLabelSetVersions] AS V WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) ON (V.[StatusId] = S.[Id])
	WHERE (@Id IS NULL OR V.[Id] = @Id) AND (@IsActive IS NULL OR V.[IsActive] = @IsActive) AND (@IsPOR IS NULL OR V.[IsPOR] = @IsPOR)
	ORDER BY V.[Version] DESC, V.[Id] DESC;

END