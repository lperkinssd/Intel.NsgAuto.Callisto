-- ===================================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-07 13:58:50.390
-- Description  : Creates an auto checker build criteria comment and returns all comments for the build criteria
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[CreateAcBuildCriteriaCommentReturnAll] NULL, @Message OUTPUT, 'bricschx', 0, 'test comment';
--                PRINT @Message; -- should print: 'Invalid build criteria: 0'
-- ===================================================================================================================================
CREATE PROCEDURE [qan].[CreateAcBuildCriteriaCommentReturnAll]
(
	  @Succeeded        BIT          OUTPUT
	, @Message          VARCHAR(500) OUTPUT
	, @UserId           VARCHAR(25)
	, @BuildCriteriaId  BIGINT
	, @Text             VARCHAR(1000) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Id BIGINT;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[CreateAcBuildCriteriaComment] @Id OUTPUT, @Message OUTPUT, @UserId, @BuildCriteriaId, @Text;

	IF (@Id IS NOT NULL) SET @Succeeded = 1;

	-- #1 result set: all build criteria comments
	SELECT * FROM [qan].[FAcBuildCriteriaComments](NULL, @BuildCriteriaId) ORDER BY [Id] DESC;

END
