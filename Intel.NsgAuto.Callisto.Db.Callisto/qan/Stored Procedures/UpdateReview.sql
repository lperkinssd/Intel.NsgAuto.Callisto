-- =============================================
-- Author:		jakemurx
-- Create date: 2020-09-30 14:37:21.654
-- Description:	Update a review
-- =============================================
CREATE PROCEDURE [qan].[UpdateReview]
	-- Add the parameters for the stored procedure here
	@Id int, 
	@ReviewRequestId int,
	@ReviewermId int,
	@ReviewStatusId int,
	@UserId varchar(50),
	@On datetime2(7)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [qan].[Reviews]
	SET [ReviewRequestId] = @ReviewRequestId,
		[ReviewerId] = @ReviewermId,
		[ReviewStatusId] = @ReviewStatusId,
		[UpdatedBy] = @UserId,
		[UpdatedOn] = @On
	WHERE [Id] = @Id
END