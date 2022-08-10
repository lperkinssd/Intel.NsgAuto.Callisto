-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-09 12:30:24.863
-- Description  : Returns all osat build criteria set reviewer email addresses that match the parameters
--                as a delimited string.
-- Example      : SELECT [qan].[OsatBuildCriteriaSetReviewerEmailsAsDelimitedString](default, 1, 1, 1);
-- =====================================================================================================
CREATE FUNCTION [qan].[OsatBuildCriteriaSetReviewerEmailsAsDelimitedString]
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
	SELECT DISTINCT [Email] FROM [qan].[OsatBuildCriteriaSetReviewers] WITH (NOLOCK)
		WHERE [VersionId] = @VersionId
		  AND ([ReviewStageId] = @ReviewStageId OR @ReviewStageId IS NULL)
		  AND ([ReviewGroupId] = @ReviewGroupId OR @ReviewGroupId IS NULL);
	SET @Result = [qan].ToDelimitedString(@EmailAddresses, @Delimiter, '');

	RETURN @Result;
END
