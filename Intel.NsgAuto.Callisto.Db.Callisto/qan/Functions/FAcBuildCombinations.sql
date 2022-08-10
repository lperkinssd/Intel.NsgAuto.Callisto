-- ==========================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-19 16:07:34.527
-- Description  : Gets auto checker build combinations
-- Example      : SELECT * FROM [qan].[FAcBuildCombinations](NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- ==========================================================================================================
CREATE FUNCTION [qan].[FAcBuildCombinations]
(
	  @Id                       INT          = NULL
	, @UserId                   VARCHAR(25)  = NULL -- if not null will restrict results to user's allowed design families
	, @DesignId                 INT          = NULL
	, @FabricationFacilityId    INT          = NULL
	, @TestFlowIdIsNull         BIT          = NULL
	, @TestFlowId               INT          = NULL
	, @ProbeConversionIdIsNull  BIT          = NULL
	, @ProbeConversionId        INT          = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  B.[Id]
		, B.[Name]
		, B.[DesignId]
		, D.[Name] AS [DesignName]
		, D.[DesignFamilyId] AS [DesignFamilyId]
		, DF.[Name] AS [DesignFamilyName]
		, D.[IsActive] AS [DesignIsActive]
		, D.[CreatedBy] AS [DesignCreatedBy]
		, D.[CreatedOn] AS [DesignCreatedOn]
		, D.[UpdatedBy] AS [DesignUpdatedBy]
		, D.[UpdatedOn] AS [DesignUpdatedOn]
		, B.[FabricationFacilityId]
		, F.[Name] AS [FabricationFacilityName]
		, B.[TestFlowId]
		, T.[Name] AS [TestFlowName]
		, B.[ProbeConversionId]
		, P.[Name] AS [ProbeConversionName]
		, B.[CreatedBy]
		, B.[CreatedOn]
		, B.[UpdatedBy]
		, B.[UpdatedOn]
	FROM [qan].[AcBuildCombinations]              AS B  WITH (NOLOCK)
	LEFT OUTER JOIN [qan].[Products]              AS D  WITH (NOLOCK) ON (D.[Id] = B.[DesignId])
	LEFT OUTER JOIN [ref].[DesignFamilies]        AS DF WITH (NOLOCK) ON (DF.[Id] = D.[DesignFamilyId])
	LEFT OUTER JOIN [qan].[FabricationFacilities] AS F  WITH (NOLOCK) ON (F.[Id] = B.[FabricationFacilityId])
	LEFT OUTER JOIN [qan].[TestFlows]             AS T  WITH (NOLOCK) ON (T.[Id] = B.[TestFlowId])
	LEFT OUTER JOIN [qan].[ProbeConversions]      AS P  WITH (NOLOCK) ON (P.[Id] = B.[ProbeConversionId])
	WHERE (@Id                      IS NULL OR B.[Id] = @Id)
	  AND (@UserId                  IS NULL OR DF.[Name] IN (SELECT [Process] FROM [qan].[UserProcessRoles] WITH (NOLOCK) WHERE [IdSid] = @UserId))
	  AND (@DesignId                IS NULL OR B.[DesignId] = @DesignId)
	  AND (@FabricationFacilityId   IS NULL OR B.[FabricationFacilityId] = @FabricationFacilityId)
	  AND (@TestFlowIdIsNull        IS NULL OR (@TestFlowIdIsNull = 0 AND B.[TestFlowId] IS NOT NULL) OR (@TestFlowIdIsNull = 1 AND B.[TestFlowId] IS NULL))
	  AND (@TestFlowId              IS NULL OR B.[TestFlowId] = @TestFlowId)
	  AND (@ProbeConversionIdIsNull IS NULL OR (@ProbeConversionIdIsNull = 0 AND B.[ProbeConversionId] IS NOT NULL) OR (@ProbeConversionIdIsNull = 1 AND B.[ProbeConversionId] IS NULL))
	  AND (@ProbeConversionId       IS NULL OR B.[ProbeConversionId] = @ProbeConversionId)
)
