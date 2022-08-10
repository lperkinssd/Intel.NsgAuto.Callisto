-- ====================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-04 14:15:43.560
-- Description  : Submits an osat build criteria set and returns all data needed for the details view
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatBuildCriteriaSetSubmittedReturnDetails] NULL, @Message OUTPUT, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid build criteria set: 0'
-- ====================================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatBuildCriteriaSetSubmittedReturnDetails]
(
	  @Succeeded  BIT OUTPUT
	, @Message    VARCHAR(500) OUTPUT
	, @UserId     VARCHAR(25)
	, @Id         BIGINT
	, @IdCompare  BIGINT = NULL
	, @Override   BIT    = NULL
	, @IsBulk Bit = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @EmailBatchId INT;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[UpdateOsatBuildCriteriaSetSubmitted] @Succeeded OUTPUT, @Message OUTPUT, @EmailBatchId OUTPUT, @UserId, @Id, @Override;

	-- #1 through #11 result sets
	EXEC [qan].[GetOsatBuildCriteriaSetDetails] @UserId, @Id, @IdCompare;

	IF (@Succeeded = 1 AND @EmailBatchId IS NOT NULL)
	BEGIN
		-- #12 result set: email templates
		SELECT * FROM [ref].[FEmailTemplates](NULL, NULL, NULL, NULL, NULL) WHERE [Id] IN (SELECT [EmailTemplateId] FROM [qan].[OsatBuildCriteriaSetReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id AND [BatchId] = @EmailBatchId);
		Declare @CriteriaText varchar(5000)=null
		-- #13 result set: emails
		IF (@IsBulk =1)
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
			  ,[VersionDescription]
			  ,[ReviewAtDescription]
			  ,[SentOn]
			  ,[Cc]
			  ,[Bcc] FROM [qan].[OsatBuildCriteriaSetReviewEmails] WITH (NOLOCK) WHERE [VersionId] = @Id AND [BatchId] = @EmailBatchId;
	END;

END
