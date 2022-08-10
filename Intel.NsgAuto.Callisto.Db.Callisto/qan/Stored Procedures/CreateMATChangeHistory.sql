
-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-22 13:16:59.839
-- Description:	Add an audit trail to the qan.MATReviewChangeHistory table
-- =============================================
CREATE PROCEDURE [qan].[CreateMATChangeHistory]
	-- Add the parameters for the stored procedure here
	@VersionId int,
	@Description varchar(max),
	@UserId varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @On DATETIME2(7) = GETUTCDATE();

	INSERT INTO [qan].[MATReviewChangeHistory]
	([VersionId], [Description], [ChangedBy], [ChangedOn])
	VALUES
	(@VersionId, @Description, @UserId, @On)
END