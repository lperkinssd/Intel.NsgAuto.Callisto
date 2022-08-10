-- ===========================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-04 10:19:45.253
-- Description  : Executes all setup CreateInitial* procedures for the review infrastructure
-- Note         : This has a dependency on the [ref].[ReviewTypes] table, so it should be
--              : executed after [setup].[CreateReviewTypes]
-- Example      : EXEC [setup].[CreateAllInitialReview] 'bricschx', 'dev';
-- ===========================================================================================
CREATE PROCEDURE [setup].[CreateAllInitialReview]
(
	  @By           VARCHAR(25) = NULL
	, @Environment  VARCHAR(5)  = 'prod'
)
AS
BEGIN
	SET NOCOUNT ON;

	-- first (if necessary) make sure [setup].[CreateReviewTypes] has been executed
	EXEC [setup].[CreateInitialReviewStages] @By;
	EXEC [setup].[CreateInitialReviewGroups] @By;
	EXEC [setup].[CreateInitialReviewers] @By;
	EXEC [setup].[CreateInitialReviewTableAssociations] @By, @Environment; -- must come after [setup].[CreateInitialReviewStages], [setup].[CreateInitialReviewGroups], and [setup].[CreateInitialReviewers]

END
