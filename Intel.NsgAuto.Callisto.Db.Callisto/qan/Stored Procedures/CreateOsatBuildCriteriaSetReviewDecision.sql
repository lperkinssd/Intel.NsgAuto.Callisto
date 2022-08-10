-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-03-01 15:35:08.680
-- Description  : Creates a new osat build criteria set review decision record
-- ============================================================================
CREATE PROCEDURE [qan].[CreateOsatBuildCriteriaSetReviewDecision]
(
	  @Id             BIGINT OUTPUT
	, @VersionId      BIGINT
	, @ReviewStageId  INT
	, @ReviewGroupId  INT
	, @ReviewerId     INT
	, @IsApproved     BIT
	, @Comment        VARCHAR(1000)
	, @ReviewedOn     DATETIME2(7) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @Id = NULL;
	IF @ReviewedOn IS NULL SET @ReviewedOn = getutcdate();

	INSERT INTO [qan].[OsatBuildCriteriaSetReviewDecisions]
	(
		  [VersionId]
		, [ReviewStageId]
		, [ReviewGroupId]
		, [ReviewerId]
		, [IsApproved]
		, [Comment]
		, [ReviewedOn]
	)
	VALUES
	(
		  @VersionId
		, @ReviewStageId
		, @ReviewGroupId
		, @ReviewerId
		, @IsApproved
		, @Comment
		, @ReviewedOn
	);

	SELECT @Id = SCOPE_IDENTITY();

END
