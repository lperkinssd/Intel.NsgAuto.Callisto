-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-01 15:33:38.817
-- Description  : Creates a new osat build criteria set review change history record
-- =================================================================================
CREATE PROCEDURE [qan].[CreateOsatBuildCriteriaSetReviewChangeHistory]
(
	  @Id           BIGINT OUTPUT
	, @VersionId    BIGINT
	, @Description  VARCHAR(MAX)
	, @By           VARCHAR(25)
	, @On           DATETIME2(7) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @On IS NULL SET @On = getutcdate();

	INSERT INTO [qan].[OsatBuildCriteriaSetReviewChangeHistory]
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
