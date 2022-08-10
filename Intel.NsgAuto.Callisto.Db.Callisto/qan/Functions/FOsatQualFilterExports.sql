-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-06-08 19:27:42.293
-- Description  : Gets osat qual filter exports
-- Example      : SELECT * FROM [qan].[FOsatQualFilterExports](NULL);
-- ============================================================================
CREATE FUNCTION [qan].[FOsatQualFilterExports]
(
	  @Id INT = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  [Id]                = E.[Id]
		, [CreatedBy]         = E.[CreatedBy]
		, [CreatedByUserName] = UC.[Name]
		, [CreatedOn]         = E.[CreatedOn]
		, [UpdatedBy]         = E.[UpdatedBy]
		, [UpdatedByUserName] = UU.[Name]
		, [UpdatedOn]         = E.[UpdatedOn]
		, [GeneratedOn]       = E.[GeneratedOn]
		, [DeliveredOn]       = E.[DeliveredOn]
		, [FileName]          = E.[FileName]
		, [FileLengthInBytes] = E.[FileLengthInBytes]
	FROM [qan].[OsatQualFilterExports] AS E WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[Users] AS UC WITH (NOLOCK) ON (UC.[IdSid] = E.[CreatedBy])
	LEFT OUTER JOIN [qan].[Users] AS UU WITH (NOLOCK) ON (UU.[IdSid] = E.[UpdatedBy])
	WHERE (@Id IS NULL OR E.[Id] = @Id)
)
