-- ===================================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-21 13:43:19.317
-- Description  : Approves an mm recipe and returns all data needed for the details view
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateMMRecipeApprovedReturnDetails] NULL, @Message OUTPUT, 'bricschx', 0, 0, 'Test comment';
--                PRINT @Message; -- should print: 'Invalid mm recipe: 0'
-- ===================================================================================================================================
CREATE PROCEDURE [qan].[UpdateMMRecipeApprovedReturnDetails]
(
	  @Succeeded           BIT          OUTPUT
	, @Message             VARCHAR(500) OUTPUT
	, @UserId              VARCHAR(25)
	, @Id                  BIGINT
	, @SnapshotReviewerId  BIGINT
	, @Comment             VARCHAR(1000) = NULL
	, @Override            BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @EmailBatchId INT;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[UpdateMMRecipeApproved] @Succeeded OUTPUT, @Message OUTPUT, @EmailBatchId OUTPUT, @UserId, @Id, @SnapshotReviewerId, @Comment, @Override;

	-- #1 through #12 result sets
	EXEC [qan].[GetMMRecipeDetails] @UserId, @Id;

	IF (@Succeeded = 1 AND @EmailBatchId IS NOT NULL)
	BEGIN
		-- #13 result set: email templates
		SELECT * FROM [ref].[FEmailTemplates](NULL, NULL, NULL, NULL, NULL) WHERE [Id] IN (SELECT [EmailTemplateId] FROM [qan].[MMRecipeReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id AND [BatchId] = @EmailBatchId);

		-- #14 result set: emails
		SELECT * FROM [qan].[MMRecipeReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id AND [BatchId] = @EmailBatchId;
	END;

END
