-- ===================================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-07 14:29:56.943
-- Description  : Rejects an auto checker build criteria and returns all data needed for the details view
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateAcBuildCriteriaRejectedReturnDetails] NULL, @Message OUTPUT, 'bricschx', 0, 0, 'Test comment';
--                PRINT @Message; -- should print: 'Invalid build criteria: 0'
-- ===================================================================================================================================
CREATE PROCEDURE [qan].[UpdateAcBuildCriteriaRejectedReturnDetails]
(
	  @Succeeded           BIT          OUTPUT
	, @Message             VARCHAR(500) OUTPUT
	, @UserId              VARCHAR(25)
	, @Id                  BIGINT
	, @SnapshotReviewerId  BIGINT
	, @Comment             VARCHAR(1000) = NULL
	, @IdCompare           BIGINT        = NULL
	, @Override            BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @EmailBatchId INT;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[UpdateAcBuildCriteriaRejected] @Succeeded OUTPUT, @Message OUTPUT, @EmailBatchId OUTPUT, @UserId, @Id, @SnapshotReviewerId, @Comment, @Override;

	-- #1 through #11 result sets
	EXEC [qan].[GetAcBuildCriteriaDetails] @UserId, @Id, @IdCompare;

	IF (@Succeeded = 1 AND @EmailBatchId IS NOT NULL)
	BEGIN
		-- #12 result set: email templates
		SELECT * FROM [ref].[FEmailTemplates](NULL, NULL, NULL, NULL, NULL) WHERE [Id] IN (SELECT [EmailTemplateId] FROM [qan].[AcBuildCriteriaReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id AND [BatchId] = @EmailBatchId);

		-- #13 result set: emails
		SELECT * FROM [qan].[AcBuildCriteriaReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id AND [BatchId] = @EmailBatchId;
	END;

END
