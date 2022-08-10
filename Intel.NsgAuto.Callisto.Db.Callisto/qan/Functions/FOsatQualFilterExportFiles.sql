-- ==========================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-16 17:17:07.717
-- Description  : Gets osat qual filter export files
-- Example      : SELECT * FROM [qan].[FOsatQualFilterExportFiles](NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- ==========================================================================================================
CREATE FUNCTION [qan].[FOsatQualFilterExportFiles]
(
	  @Id              INT = NULL
	, @ExportId        INT = NULL
	, @OsatId          INT = NULL
	, @DesignId        INT = NULL
	, @DesignFamilyId  INT = NULL
	, @Generated       BIT = NULL
	, @Delivered       BIT = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  [Id]                = F.[Id]
		, [ExportId]          = F.[ExportId]
		, [OsatId]            = F.[OsatId]
		, [OsatName]          = O.[Name]
		, [OsatCreatedBy]     = O.[CreatedBy]
		, [OsatCreatedOn]     = O.[CreatedOn]
		, [OsatUpdatedBy]     = O.[UpdatedBy]
		, [OsatUpdatedOn]     = O.[UpdatedOn]
		, [DesignId]          = F.[DesignId]
		, [DesignName]        = D.[Name]
		, [DesignFamilyId]    = D.[DesignFamilyId]
		, [DesignFamilyName]  = DF.[Name]
		, [DesignIsActive]    = D.[IsActive]
		, [DesignCreatedBy]   = D.[CreatedBy]
		, [DesignCreatedOn]   = D.[CreatedOn]
		, [DesignUpdatedBy]   = D.[UpdatedBy]
		, [DesignUpdatedOn]   = D.[UpdatedOn]
		, [CreatedBy]         = F.[CreatedBy]
		, [CreatedByUserName] = UC.[Name]
		, [CreatedOn]         = F.[CreatedOn]
		, [UpdatedBy]         = F.[UpdatedBy]
		, [UpdatedByUserName] = UU.[Name]
		, [UpdatedOn]         = F.[UpdatedOn]
		, [GeneratedOn]       = F.[GeneratedOn]
		, [DeliveredOn]       = F.[DeliveredOn]
		, [Name]              = F.[Name]
		, [LengthInBytes]     = F.[LengthInBytes]
	FROM [qan].[OsatQualFilterExportFiles] AS F  WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[Osats]          AS O  WITH (NOLOCK) ON (O.[Id] = F.[OsatId])
	LEFT OUTER JOIN [qan].[Products]       AS D  WITH (NOLOCK) ON (D.[Id] = F.[DesignId])
	LEFT OUTER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Id] = D.[DesignFamilyId])
	LEFT OUTER JOIN [qan].[Users]          AS UC WITH (NOLOCK) ON (UC.[IdSid] = F.[CreatedBy])
	LEFT OUTER JOIN [qan].[Users]          AS UU WITH (NOLOCK) ON (UU.[IdSid] = F.[UpdatedBy])
	WHERE (@Id             IS NULL OR F.[Id]             = @Id)
	  AND (@ExportId       IS NULL OR F.[ExportId]       = @ExportId)
	  AND (@OsatId         IS NULL OR F.[OsatId]         = @OsatId)
	  AND (@DesignId       IS NULL OR F.[DesignId]       = @DesignId)
	  AND (@DesignFamilyId IS NULL OR D.[DesignFamilyId] = @DesignFamilyId)
	  AND (@Generated      IS NULL OR (@Generated = 0 AND F.[GeneratedOn] IS NULL) OR (@Generated = 1 AND F.[GeneratedOn] IS NOT NULL))
	  AND (@Delivered      IS NULL OR (@Delivered = 0 AND F.[DeliveredOn] IS NULL) OR (@Delivered = 1 AND F.[DeliveredOn] IS NOT NULL))
)
