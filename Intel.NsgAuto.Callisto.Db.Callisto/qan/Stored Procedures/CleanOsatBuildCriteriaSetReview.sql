-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-04 14:12:23.683
-- Description  : Cleans all associated review records for the specified osat build criteria set
-- Example      : EXEC [qan].[CleanOsatBuildCriteriaSetReview] 0, 'bricschx';
-- ================================================================================================
CREATE PROCEDURE [qan].[CleanOsatBuildCriteriaSetReview]
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

		DELETE FROM [qan].[OsatBuildCriteriaSetReviewStages] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Stages: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[OsatBuildCriteriaSetReviewGroups] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Groups: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[OsatBuildCriteriaSetReviewers] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Reviewers: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[OsatBuildCriteriaSetReviewDecisions] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Decisions: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		DELETE FROM [qan].[OsatBuildCriteriaSetReviewEmails] WHERE [VersionId] = @Id;
		SET @Description = @Description + '; Emails: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

		EXEC [qan].[CreateUserAction] NULL, @UserId, @Description, 'OSAT', @ActionType, 'OsatBuildCriteriaSet', @Id;

	COMMIT;

END
