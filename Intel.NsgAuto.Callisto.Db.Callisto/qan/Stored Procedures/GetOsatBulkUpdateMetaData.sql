CREATE  PROCEDURE [qan].[GetOsatBulkUpdateMetaData]
(
	  @UserId  VARCHAR(25)
	, @Id      INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Return design ids for the user for the process that he has access to
	SELECT * FROM [qan].[FProducts](@Id, @UserId, NULL, NULL, NULL, NULL)
	ORDER BY [Name];

	DECLARE @Process VARCHAR(50) = (
		SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK)
		INNER JOIN [qan].[ProcessRoles] pr  WITH (NOLOCK)
		ON pfr.ActiveRole = pr.RoleName
		WHERE pfr.UserId = @UserId);


			SELECT  
             DISTINCT D.Id,
                [OBCSBUIR].OsatId as OsatId,
                D.Name
                , 'Version ' + CAST([OBCSBUIR].FileVersion as VARCHAR(255)) + ' - ' +( ( SELECT  distinct  ',' + cast(ss1.Name as VARCHAR(255))    as [text()]         
              FROM  [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords]  [OBCSBUIR1]            
              INNER JOIN [qan].[OsatBuildCriteriaSets]       AS S1   WITH (NOLOCK) ON (S1.[Id] = [OBCSBUIR1].[BuildCriteriaSetId])        
              INNER JOIN [ref].[Statuses]                    AS SS1   WITH (NOLOCK) ON (SS1.[Id] = s1.StatusId)         
              where  [OBCSBUIR].ImportId=[OBCSBUIR1].ImportId
              for xml path (''))) + ', ' + s.CreatedBy as VersionName,
                     S.StatusId,
                     [OBCSBUIR].FileVersion AS VersionId,
                     S.CreatedBy,
                     [OBCSBUIR].[ImportId]
              FROM  [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords]  [OBCSBUIR]
              --qan].[OsatBuildCriterias]                AS BC  WITH (NOLOCK)
              INNER JOIN [qan].[OsatBuildCriteriaSets]       AS S   WITH (NOLOCK) ON (S.[Id] = [OBCSBUIR].[BuildCriteriaSetId])
              --INNER JOIN [qan].[OsatBuildCombinations]       AS C   WITH (NOLOCK) ON (C.[Id] = S.[BuildCombinationId])    
              --INNER JOIN  [qan].[OsatBuildCombinationOsats]   AS CO  WITH (NOLOCK) ON (CO.[BuildCombinationId] = C.[Id])
              INNER JOIN [qan].[Products]                    AS D   WITH (NOLOCK) ON (D.[Id] =  [OBCSBUIR].[DesignId])
              INNER JOIN [ref].[Statuses]                    AS SS   WITH (NOLOCK) ON (SS.[Id] = s.StatusId)
              INNER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Id] = D.[DesignFamilyId])
              WHERE DF.[Name] = 'NAND'
              ORDER BY [OBCSBUIR].FileVersion DESC


		-- SELECT  
	 --     DISTINCT D.Id,
		--  [OBCSBUIR].OsatId as OsatId,
		--  D.Name
		--  , 'Version ' + CAST([OBCSBUIR].FileVersion as VARCHAR(255)) + ' - ' + cast(ss.Name as VARCHAR(255)) + ', ' + s.CreatedBy as VersionName,
		--	S.StatusId,
		--	[OBCSBUIR].FileVersion AS VersionId,
		--	S.CreatedBy,
		--	[OBCSBUIR].[ImportId]
		--FROM  [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords]  [OBCSBUIR]
		----qan].[OsatBuildCriterias]                AS BC  WITH (NOLOCK)
		--INNER JOIN [qan].[OsatBuildCriteriaSets]       AS S   WITH (NOLOCK) ON (S.[Id] = [OBCSBUIR].[BuildCriteriaSetId])
		----INNER JOIN [qan].[OsatBuildCombinations]       AS C   WITH (NOLOCK) ON (C.[Id] = S.[BuildCombinationId])	
		----INNER JOIN  [qan].[OsatBuildCombinationOsats]   AS CO  WITH (NOLOCK) ON (CO.[BuildCombinationId] = C.[Id])
		--INNER JOIN [qan].[Products]                    AS D   WITH (NOLOCK) ON (D.[Id] =  [OBCSBUIR].[DesignId])
		--INNER JOIN [ref].[Statuses]                    AS SS   WITH (NOLOCK) ON (SS.[Id] = s.StatusId)
		--INNER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Id] = D.[DesignFamilyId])
		--WHERE DF.[Name] = @Process
		--ORDER BY [OBCSBUIR].FileVersion DESC
	
 --   SELECT  
	--DISTINCT D.Id,
	--	  D.Name
	--	  , 'Version ' + CAST(S.Version as VARCHAR(255)) + ' - ' + cast(ss.Name as VARCHAR(255)) + ', ' + s.CreatedBy as VersionName,
	--		S.StatusId,
	--		S.Version AS VersionId,
	--		S.CreatedBy,
	--		[OBCSBUIR].[ImportId]
	--	FROM [qan].[OsatBuildCriterias]                AS BC  WITH (NOLOCK)
	--	INNER JOIN [qan].[OsatBuildCriteriaSets]       AS S   WITH (NOLOCK) ON (S.[Id] = BC.[BuildCriteriaSetId])
	--	INNER JOIN [qan].[OsatBuildCombinations]       AS C   WITH (NOLOCK) ON (C.[Id] = S.[BuildCombinationId])	
	--	INNER JOIN [qan].[Products]                    AS D   WITH (NOLOCK) ON (D.[Id] = C.[DesignId])
	--	INNER JOIN [ref].[Statuses]                    AS SS   WITH (NOLOCK) ON (SS.[Id] = s.StatusId)
	--	INNER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Id] = D.[DesignFamilyId])
	--	INNER JOIN (select * from [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords]  ) AS [OBCSBUIR] ON [OBCSBUIR].[BuildCriteriaSetId]=S.[Id] and S.[BuildCombinationId] = [OBCSBUIR].BuildCombinationId
	--	WHERE DF.[Name] = @Process
	--	ORDER BY [VersionId] DESC

	SELECT * FROM [qan].[Osats] WITH (NOLOCK) ORDER BY [Name];

END
