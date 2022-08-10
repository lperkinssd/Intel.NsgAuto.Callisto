-- ========================================================
-- Author       : bricschx
-- Create date  : 2020-09-21 19:16:16.703
-- Description  : Gets tasks
-- Example      : EXEC [stage].[GetTasks] 'bricschx', 1;
-- ========================================================
CREATE PROCEDURE [stage].[GetTasks]
(
	  @UserId                VARCHAR(25)
	, @Id                    BIGINT       = NULL
	, @TaskTypeId            INT          = NULL
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
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [stage].[FTasks](@Id, @TaskTypeId, NULL, @Status, @StartDateTimeMin, @StartDateTimeMax, @StartDateTimeNull, @EndDateTimeMin, @EndDateTimeMax, @EndDateTimeNull, @AbortDateTimeMin, @AbortDateTimeMax, @AbortDateTimeNull, @ResolvedDateTimeMin, @ResolvedDateTimeMax, @ResolvedDateTimeNull, @ResolvedBy) ORDER BY [Id] DESC;

END
