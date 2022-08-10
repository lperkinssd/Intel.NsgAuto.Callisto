CREATE PROCEDURE [qan].[GetOsatBuildCriteriaConditions]
(
	  @DesignId                INT = NULL
	, @OsatId                  INT = NULL
	, @IncludePublishDisabled  BIT = NULL
	, @IncludeStatusInReview   BIT = NULL
	, @IncludeStatusSubmitted  BIT = NULL
	, @IncludeStatusDraft      BIT = NULL
)
AS
BEGIN
    
		SELECT
			  [BuildCriteriaSetId]               = S.[Id]
			, S.[BuildCombinationId]
			, [BuildCriteriaId]                  = BC.[Id]
			, [BuildCriteriaSetStatusId]         = S.[StatusId]
			, [PackageDieTypeName]               = PDT.[Name]
			, [BuildCriteriaName]                = BC.[Name]
			, [AttributeId]											 = [BCC].[Id]
			, [AttributeComparisonOperationId]	 = [BCC].[ComparisonOperationId]
			, [AttributeComparisonOperationKey]	 = [OC].[Key]
			, BCC.[AttributeTypeId]
			, [AttributeTypeName]                = T.[Name]
			, [AttributeValue]                   = BCC.[Value]
			, [PartNumberDecode]                 = C.[DeviceName]
			, [DeviceName]						 = C.[IntelLevel1PartNumber]
		FROM [qan].[OsatBuildCriterias]                     AS BC  WITH (NOLOCK)
		LEFT OUTER JOIN [qan].[OsatBuildCriteriaSets]       AS S   WITH (NOLOCK) ON (S.[Id] = BC.[BuildCriteriaSetId])
		INNER JOIN (
						SELECT MAX([Version]) [Version], [BuildCombinationId] 
						FROM [qan].[OsatBuildCriteriaSets]
						WHERE [IsPOR]=1
						GROUP BY [BuildCombinationId]
		) LV ON  [LV].[BuildCombinationId]=S.[BuildCombinationId] AND LV.[Version] = [S].[Version]
		LEFT OUTER JOIN [qan].[OsatBuildCombinations]       AS C   WITH (NOLOCK) ON (C.[Id] = S.[BuildCombinationId])
	--	LEFT OUTER JOIN [qan].[OsatBuildCombinationOsats]   AS CO  WITH (NOLOCK) ON (CO.[BuildCombinationId] = C.[Id])
		LEFT OUTER JOIN [qan].[Osats]                       AS O   WITH (NOLOCK) ON (O.[Id] = C.[Osatid])
		LEFT OUTER JOIN [qan].[Products]                    AS D   WITH (NOLOCK) ON (D.[Id] = C.[DesignId])
		LEFT OUTER JOIN [ref].[DesignFamilies]              AS DF  WITH (NOLOCK) ON (DF.[Id] = D.[DesignFamilyId])
		LEFT OUTER JOIN [ref].[PartUseTypes]                AS PUT WITH (NOLOCK) ON (PUT.[Id] = C.[PartUseTypeId])
		LEFT OUTER JOIN [qan].[OsatPackageDieTypes]         AS PDT WITH (NOLOCK) ON (PDT.[Id] = C.[PackageDieTypeId])
		LEFT OUTER JOIN [qan].[OsatBuildCriteriaConditions] AS BCC WITH (NOLOCK) ON (BCC.[BuildCriteriaId] = BC.[Id])
		LEFT OUTER JOIN [qan].[OsatAttributeTypes]          AS T   WITH (NOLOCK) ON (T.[Id] = BCC.[AttributeTypeId])
		LEFT OUTER JOIN [ref].[Statuses]                    AS ST  WITH (NOLOCK) ON (ST.[Id] = S.[StatusId])
		LEFT OUTER JOIN [ref].[OsatComparisonOperations]    AS OC WITH (NOLOCK) ON (OC.[Id] = [BCC].[ComparisonOperationId])
		WHERE
			    (@DesignId IS NULL OR C.[DesignId] = @DesignId)
			AND (@OsatId   IS NULL OR C.[Osatid]  = @OsatId)
			AND (@IncludePublishDisabled = 1 OR C.[PublishDisabledOn] IS NULL)
			AND
				(
					   S.[IsPOR] = 1
					OR (@IncludeStatusInReview  = 1 AND S.[StatusId] = 5)
					OR (@IncludeStatusSubmitted = 1 AND S.[StatusId] = 3)
					OR (@IncludeStatusDraft     = 1 AND S.[StatusId] = 1)
				)
		ORDER BY [BuildCriteriaSetId]    

END