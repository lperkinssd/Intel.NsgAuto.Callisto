-- ===================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-01 15:29:11.097
-- Description  : Creates an osat build criteria set comment and returns all comments for the build criteria set
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[CreateOsatBuildCriteriaSetCommentReturnAll] NULL, @Message OUTPUT, 'bricschx', 0, 'test comment';
--                PRINT @Message; -- should print: 'Invalid build criteria set: 0'
-- ===================================================================================================================================
CREATE PROCEDURE [qan].[CreateOsatBuildCriteriaSetCommentReturnAll]
(
	  @Succeeded           BIT          OUTPUT
	, @Message             VARCHAR(500) OUTPUT
	, @UserId              VARCHAR(25)
	, @BuildCriteriaSetId  BIGINT
	, @Text                VARCHAR(1000) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Id BIGINT;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[CreateOsatBuildCriteriaSetComment] @Id OUTPUT, @Message OUTPUT, @UserId, @BuildCriteriaSetId, @Text;

	IF (@Id IS NOT NULL) SET @Succeeded = 1;

	-- #1 result set: all build criteria set comments
	SELECT * FROM [qan].[FOsatBuildCriteriaSetComments](NULL, @BuildCriteriaSetId) ORDER BY [Id] DESC;

END
