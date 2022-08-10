-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-07 11:36:42.553
-- Description  : Cleans all associated review records for the specified auto checker build criteria
-- Example      : EXEC [qan].[CleanAcBuildCriteriaReview] 0, 'bricschx';
-- =====================================================================================================
CREATE PROCEDURE [qan].[CleanAcBuildCriteriaReview]
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

		DELETE FROM [qan].[AcBuildCriteriaReviewStages] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Stages: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[AcBuildCriteriaReviewGroups] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Groups: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[AcBuildCriteriaReviewers] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Reviewers: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[AcBuildCriteriaReviewDecisions] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Decisions: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[AcBuildCriteriaReviewEmails] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Emails: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		EXEC [qan].[CreateUserAction] NULL, @UserId, @Description, 'Auto Checker', @ActionType, 'AcBuildCriteria', @Id;

	COMMIT;

END
