-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-09 11:51:59.877
-- Description  : Returns all auto checker build reviewer email addresses that match the parameters
--                as a delimited string.
-- Example      : SELECT [qan].[AcBuildCriteriaReviewerEmailsAsDelimitedString](default, 42, 3, 4);
-- ================================================================================================
CREATE FUNCTION [qan].[AcBuildCriteriaReviewerEmailsAsDelimitedString]
(
	  @Delimiter      VARCHAR(10)  = ','
	, @VersionId      BIGINT
	, @ReviewStageId  INT          = NULL
	, @ReviewGroupId  INT          = NULL
)
RETURNS VARCHAR(2000)
AS
BEGIN
	DECLARE @EmailAddresses  [qan].[IStrings];
	DECLARE @Result          VARCHAR(2000);

	INSERT INTO @EmailAddresses
	SELECT DISTINCT [Email] FROM [qan].[AcBuildCriteriaReviewers] WITH (NOLOCK)
		WHERE [VersionId] = @VersionId
		  AND ([ReviewStageId] = @ReviewStageId OR @ReviewStageId IS NULL)
		  AND ([ReviewGroupId] = @ReviewGroupId OR @ReviewGroupId IS NULL);
	SET @Result = [qan].ToDelimitedString(@EmailAddresses, @Delimiter, '');

	RETURN @Result;
END
