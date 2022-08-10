-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-02 18:02:03.787
-- Description  : Creates a new auto checker build criteria review decision record
-- =================================================================================
CREATE PROCEDURE [qan].[CreateAcBuildCriteriaReviewDecision]
(
	  @Id BIGINT OUTPUT
	, @VersionId BIGINT
	, @ReviewStageId INT
	, @ReviewGroupId INT
	, @ReviewerId INT
	, @IsApproved BIT
	, @Comment VARCHAR(1000)
	, @ReviewedOn DATETIME2(7) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @Id = NULL;
	IF @ReviewedOn IS NULL SET @ReviewedOn = getutcdate();

	INSERT INTO [qan].[AcBuildCriteriaReviewDecisions]
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
