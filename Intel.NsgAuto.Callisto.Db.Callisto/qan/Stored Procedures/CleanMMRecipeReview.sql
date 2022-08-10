-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-18 14:44:48.463
-- Description  : Cleans all associated review records for the specified mm recipe
-- Example      : EXEC [qan].[CleanMMRecipeReview] 0, 'bricschx';
-- =====================================================================================================
CREATE PROCEDURE [qan].[CleanMMRecipeReview]
(
	  @Id BIGINT
	, @UserId VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionType VARCHAR(100) = 'Review Clean';
	DECLARE @Description VARCHAR (1000) = @ActionType;

	BEGIN TRANSACTION

		DELETE FROM [qan].[MMRecipeReviewStages] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Stages: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[MMRecipeReviewGroups] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Groups: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[MMRecipeReviewers] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Reviewers: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[MMRecipeReviewDecisions] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Decisions: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[MMRecipeReviewEmails] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Emails: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		EXEC [qan].[CreateUserAction] NULL, @UserId, @Description, 'MM Recipe', @ActionType, 'MMRecipe', @Id;

	COMMIT;

END
