-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-02 18:02:03.787
-- Description  : Creates a new auto checker build criteria review change history record
-- ======================================================================================
CREATE PROCEDURE [qan].[CreateAcBuildCriteriaReviewChangeHistory]
(
	  @Id BIGINT OUTPUT
	, @VersionId BIGINT
	, @Description VARCHAR(MAX)
	, @By VARCHAR(25)
	, @On DATETIME2(7) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @On IS NULL SET @On = getutcdate();

	INSERT INTO [qan].[AcBuildCriteriaReviewChangeHistory]
	(
		  [VersionId]
		, [Description]
		, [ChangedBy]
		, [ChangedOn]
	)
	VALUES
	(
		  @VersionId
		, @Description
		, @By
		, @On
	);

	SELECT @Id = SCOPE_IDENTITY();

END
