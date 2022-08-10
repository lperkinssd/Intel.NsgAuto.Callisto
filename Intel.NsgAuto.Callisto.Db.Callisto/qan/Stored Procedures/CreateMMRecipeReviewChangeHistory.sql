-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-18 14:53:50.207
-- Description  : Creates a new mm recipe review change history record
-- ======================================================================================
CREATE PROCEDURE [qan].[CreateMMRecipeReviewChangeHistory]
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

	INSERT INTO [qan].[MMRecipeReviewChangeHistory]
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
