-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-04-19 16:49:48.910
-- Description  : Gets osat qual filter records
-- Example      : EXEC [qan].[GetOsatQualFilterRecords] 'bricschx', 1;
-- =======================================================================
CREATE PROCEDURE [qan].[GetOsatQualFilterRecords]
(
	  @UserId                  VARCHAR(25)
	, @DesignId                INT         = NULL
	, @OsatId                  INT         = NULL
	, @IncludePublishDisabled  BIT         = NULL
	, @IncludeStatusInReview   BIT         = NULL
	, @IncludeStatusSubmitted  BIT         = NULL
	, @IncludeStatusDraft      BIT         = NULL
	, @StatusId                INT         = NULL
	, @VersionId               INT         = NULL
	, @CreatedBy               VARCHAR(25) = NULL
	, @IsPOR				BIT         = 1
	, @ImportId				INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

IF @ImportId IS NOT NULL
BEGIN
  SET @IsPOR = (
                 SELECT
                            TOP 1
                            IsPOR
                 FROM
                            [qan].[OsatBuildCriteriaSets]                       AS [OBCS]
                 INNER JOIN [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords] AS [OBCSBUIR]
                            ON [OBCSBUIR].[BuildCriteriaSetId] = [OBCS].[Id]
                               AND [OBCSBUIR].[ImportId]       = @ImportId
               );
END;

IF (@DesignId=0)
	SET @DesignId =null

-- New Code by Suresh --2/10/22
 DECLARE @Process Varchar(MAX);
	 SET @Process = (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                  INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);
-- New Code by Suresh --2/10/22

	SELECT * FROM [qan].[FOsatQualFilterRecords](@DesignId, @OsatId, @IncludePublishDisabled, @IncludeStatusInReview, @IncludeStatusSubmitted, @IncludeStatusDraft, @StatusId, @VersionId, @CreatedBy, @IsPOR) R
	WHERE DesignFamilyName =@Process and
	@ImportId IS NULL OR EXISTS(SELECT 1 FROM [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords] IR WHERE IR.ImportId=@ImportId AND IR.[BuildCriteriaSetId]=[R].[BuildCriteriaSetId])
	ORDER BY [OsatId], [DesignId], [PackageDieTypeName], [BuildCriteriaSetId], [BuildCriteriaOrdinal];

END
GO
