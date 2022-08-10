-- ========================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-04 14:39:28.350
-- Description  : Approves an osat build criteria set and returns all data needed for the details view
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatBuildCriteriaSetApprovedReturnDetails] NULL, @Message OUTPUT, 'bricschx', 0, 0, 'Test comment';
--                PRINT @Message; -- should print: 'Invalid build criteria set: 0'
-- ========================================================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatBuildCriteriaSetApprovedReturnDetails]
(
	  @Succeeded           BIT          OUTPUT
	, @Message             VARCHAR(500) OUTPUT
	, @UserId              VARCHAR(25)
	, @Id                  BIGINT
	, @SnapshotReviewerId  BIGINT
	, @Comment             VARCHAR(1000) = NULL
	, @IdCompare           BIGINT        = NULL
	, @Override            BIT           = NULL
	, @isBulk			   BIT			 = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @EmailBatchId INT;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[UpdateOsatBuildCriteriaSetApproved] @Succeeded OUTPUT, @Message OUTPUT, @EmailBatchId OUTPUT, @UserId, @Id, @SnapshotReviewerId, @Comment, @Override;

	-- #1 through #11 result sets
	EXEC [qan].[GetOsatBuildCriteriaSetDetails] @UserId, @Id, @IdCompare;

	IF (@Succeeded = 1 AND @EmailBatchId IS NOT NULL)
	BEGIN
		-- #12 result set: email templates
		SELECT * FROM [ref].[FEmailTemplates](NULL, NULL, NULL, NULL, NULL) WHERE [Id] IN (SELECT [EmailTemplateId] FROM [qan].[OsatBuildCriteriaSetReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id AND [BatchId] = @EmailBatchId);
		Declare @CriteriaText varchar(5000)=null
		IF (@isBulk =1)
		BEGIN
			 
			select @CriteriaText = stuff((select '<br> ' + IntelProdName + ' ' +MaterialMasterField + ' ' + AssyUpi + ' [Version ' + CAST([Version] AS VARCHAR(20)) + ']' 
						from qan.OsatBuildCombinations BC INNER JOIN

						(select BuildCombinationId, Version as Version from qan.OsatBuildCriteriaSets where Id in (

								SELECT distinct BuildCriteriaSetId from [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords] where ImportId in 
									(Select ImportId from [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords] where BuildCriteriaSetId = @Id))) BS ON BC.Id = BS.BuildCombinationId
									 for xml path ('')),  1, 1, '')
			SELECT [Id]
			  ,[VersionId]
			  ,[BatchId]
			  ,[SnapshotReviewStageId]
			  ,[ReviewStageId]
			  ,[SnapshotReviewGroupId]
			  ,[ReviewGroupId]
			  ,[EmailTemplateId]
			  ,[EmailTemplateName]
			  ,[To]
			  ,[RecipientName]
			  ,@CriteriaText as [VersionDescription]
			  ,[ReviewAtDescription]
			  ,[SentOn]
			  ,[Cc]
			  ,[Bcc] FROM [qan].[OsatBuildCriteriaSetReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id AND [BatchId] = @EmailBatchId;
		END
		ELSE
		-- #13 result set: emails
			SELECT * FROM [qan].[OsatBuildCriteriaSetReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id AND [BatchId] = @EmailBatchId;
	END;

END
