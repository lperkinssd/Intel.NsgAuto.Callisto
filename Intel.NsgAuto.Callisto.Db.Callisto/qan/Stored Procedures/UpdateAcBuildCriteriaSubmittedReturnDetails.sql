-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 17:50:24.260
-- Description  : Submits an auto checker build criteria and returns all data needed for the details view
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateAcBuildCriteriaSubmittedReturnDetails] NULL, @Message OUTPUT, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid build criteria: 0'
-- ===============================================================================================================
CREATE PROCEDURE [qan].[UpdateAcBuildCriteriaSubmittedReturnDetails]
(
	  @Succeeded  BIT OUTPUT
	, @Message    VARCHAR(500) OUTPUT
	, @UserId     VARCHAR(25)
	, @Id         BIGINT
	, @IdCompare  BIGINT = NULL
	, @Override   BIT    = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @EmailBatchId INT;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[UpdateAcBuildCriteriaSubmitted] @Succeeded OUTPUT, @Message OUTPUT, @EmailBatchId OUTPUT, @UserId, @Id, @Override;

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
