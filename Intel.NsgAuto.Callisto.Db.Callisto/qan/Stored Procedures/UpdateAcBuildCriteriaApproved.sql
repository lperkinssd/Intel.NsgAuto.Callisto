
-- =========================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 17:10:27.030
-- Description  : Approves an auto checker build criteria
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateAcBuildCriteriaApproved] NULL, @Message OUTPUT, NULL, 'bricschx', 0, 0, 'Test comment';
--                PRINT @Message; -- should print: 'Invalid build criteria: 0'
-- =========================================================================================================================
CREATE PROCEDURE [qan].[UpdateAcBuildCriteriaApproved]
(
	   @Succeeded           BIT                   OUTPUT
	, @Message             VARCHAR(500)          OUTPUT
	, @EmailBatchId        INT                   OUTPUT
	, @UserId              VARCHAR(25)
	, @Id                  BIGINT
	, @SnapshotReviewerId  BIGINT
	, @Comment             VARCHAR(1000) = NULL
	, @Override            BIT           = 0
)
AS
BEGIN
	SET NOCOUNT ON;	
	DECLARE @Roles           INT;
	DECLARE @RoleName		 NVARCHAR(50);
	 			
	SELECT @RoleName = ActiveRole
	FROM [Callisto].[qan].[PreferredRole]
	WHERE UserId = @UserId

	if(@RoleName = 'Callisto_Nand_User')  --NAND	
		EXEC [npsg].[PublishAcBuildCriteriaApproved] @Succeeded, @Message, @EmailBatchId, @UserId, @Id, @SnapshotReviewerId, @Comment, @Override;
	
	if(@RoleName = 'Callisto_Optane_User') --Optane	
		EXEC [qan].[PublishAcBuildCriteriaApproved] @Succeeded, @Message, @EmailBatchId, @UserId, @Id, @SnapshotReviewerId, @Comment, @Override;
		
	SET @Succeeded = 1;
	
END