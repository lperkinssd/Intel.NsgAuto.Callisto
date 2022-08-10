-- =======================================================================
-- Author       : bricschx
-- Create date  : 2021-03-01 16:52:18.190
-- Description  : Gets osat build criteria sets
-- Example      : EXEC [qan].[GetOsatBuildCriteriaSets] 'bricschx', 1;
-- =======================================================================
CREATE PROCEDURE [qan].[GetOsatBuildCriteriaSets]
(
	  @UserId              VARCHAR(25) = NULL
	, @Id                  BIGINT      = NULL
	, @Version             INT         = NULL
	, @IsPOR               BIT         = NULL
	, @IsActive            BIT         = NULL
	, @StatusId            INT         = NULL
	, @BuildCombinationId  INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [qan].[FOsatBuildCriteriaSets](@Id, @UserId, @Version, @IsPOR, @IsActive, @StatusId, @BuildCombinationId) ORDER BY [UpdatedOn] DESC, [Id] DESC;

END
