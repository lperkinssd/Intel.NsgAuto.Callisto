-- =======================================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-07 16:48:20.963
-- Description  : Gets tasks
-- Note         : Any function parameters supplied will filter results
-- Example      : SELECT * FROM [stage].[FTasks](1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- =======================================================================================================================================================
CREATE FUNCTION [stage].[FTasks]
(
	  @Id                    BIGINT       = NULL
	, @TaskTypeId            INT          = NULL
	, @TaskTypeName          VARCHAR(100) = NULL
	, @Status                VARCHAR(50)  = NULL
	, @StartDateTimeMin      DATETIME2(7) = NULL
	, @StartDateTimeMax      DATETIME2(7) = NULL
	, @StartDateTimeNull     BIT          = NULL
	, @EndDateTimeMin        DATETIME2(7) = NULL
	, @EndDateTimeMax        DATETIME2(7) = NULL
	, @EndDateTimeNull       BIT          = NULL
	, @AbortDateTimeMin      DATETIME2(7) = NULL
	, @AbortDateTimeMax      DATETIME2(7) = NULL
	, @AbortDateTimeNull     BIT          = NULL
	, @ResolvedDateTimeMin   DATETIME2(7) = NULL
	, @ResolvedDateTimeMax   DATETIME2(7) = NULL
	, @ResolvedDateTimeNull  BIT          = NULL
	, @ResolvedBy            VARCHAR(25)  = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  *
		, [Problematic]                     = CAST(CASE WHEN [ResolvedDateTime] IS NULL AND [EndDateTime] IS NULL AND ([AbortDateTime] IS NOT NULL OR [ElapsedMinutes] > [TaskTypeThresholdTimeLimit]) THEN 1 ELSE 0 END AS BIT)
	FROM
	(
		SELECT
			  [Id]                          = T.[Id]
			, [TaskTypeId]                  = T.[TaskTypeId]
			, [TaskTypeName]                = TT.[Name]
			, [TaskTypeThresholdTimeLimit]  = TT.[ThresholdTimeLimit]
			, [TaskTypeCodeLocation]        = TT.[CodeLocation]
			, [Status]                      = T.[Status]
			, [StartDateTime]               = T.[StartDateTime]
			, [EndDateTime]                 = T.[EndDateTime]
			, [AbortDateTime]               = T.[AbortDateTime]
			, [ResolvedDateTime]            = T.[ResolvedDateTime]
			, [ResolvedBy]                  = T.[ResolvedBy]
			, [ProgressPercent]             = T.[ProgressPercent]
			, [ProgressText]                = T.[ProgressText]
			, [ElapsedMinutes]              = DATEDIFF(MINUTE, T.[StartDateTime], ISNULL(T.[EndDateTime], ISNULL(T.[AbortDateTime], ISNULL(T.[ResolvedDateTime], GETUTCDATE()))))
		FROM [stage].[Tasks] AS T WITH (NOLOCK)
		LEFT OUTER JOIN [ref].[TaskTypes] AS TT WITH (NOLOCK) ON (TT.[Id] = T.[TaskTypeId])
		WHERE (@Id IS NULL OR T.[Id] = @Id)
		  AND (@TaskTypeId IS NULL OR TT.[Id] = @TaskTypeId)
		  AND (@TaskTypeName IS NULL OR TT.[Name] = @TaskTypeName)
		  AND (@Status IS NULL OR T.[Status] = @Status)
		  AND (@StartDateTimeMin IS NULL OR T.[StartDateTime] >= @StartDateTimeMin)
		  AND (@StartDateTimeMax IS NULL OR T.[StartDateTime] <= @StartDateTimeMax)
		  AND (@StartDateTimeNull IS NULL OR (@StartDateTimeNull = 1 AND T.[StartDateTime] IS NULL) OR (@StartDateTimeNull = 0 AND T.[StartDateTime] IS NOT NULL))
		  AND (@EndDateTimeMin IS NULL OR T.[EndDateTime] >= @EndDateTimeMin)
		  AND (@EndDateTimeMax IS NULL OR T.[EndDateTime] <= @EndDateTimeMax)
		  AND (@EndDateTimeNull IS NULL OR (@EndDateTimeNull = 1 AND T.[EndDateTime] IS NULL) OR (@EndDateTimeNull = 0 AND T.[EndDateTime] IS NOT NULL))
		  AND (@AbortDateTimeMin IS NULL OR T.[AbortDateTime] >= @AbortDateTimeMin)
		  AND (@AbortDateTimeMax IS NULL OR T.[AbortDateTime] <= @AbortDateTimeMax)
		  AND (@AbortDateTimeNull IS NULL OR (@AbortDateTimeNull = 1 AND T.[AbortDateTime] IS NULL) OR (@AbortDateTimeNull = 0 AND T.[AbortDateTime] IS NOT NULL))
		  AND (@ResolvedDateTimeMin IS NULL OR T.[ResolvedDateTime] >= @ResolvedDateTimeMin)
		  AND (@ResolvedDateTimeMax IS NULL OR T.[ResolvedDateTime] <= @ResolvedDateTimeMax)
		  AND (@ResolvedDateTimeNull IS NULL OR (@ResolvedDateTimeNull = 1 AND T.[ResolvedDateTime] IS NULL) OR (@ResolvedDateTimeNull = 0 AND T.[ResolvedDateTime] IS NOT NULL))
		  AND (@ResolvedBy IS NULL OR T.[ResolvedBy] = @ResolvedBy)
	) AS Z
)
