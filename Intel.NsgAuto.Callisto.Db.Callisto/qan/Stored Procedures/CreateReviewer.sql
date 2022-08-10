-- =============================================
-- Author:		jakemurx
-- Create date: 2020-09-29 16:43:22.043
-- Description:	Create a reviewer
--         EXEC [qan].[CreateReviewer] 'Jake Douglas', 'jakemurx', '10995566', 'jakex.murphy.douglas@intel.com', 1
-- =============================================
CREATE PROCEDURE [qan].[CreateReviewer] 
	-- Add the parameters for the stored procedure here
	@Name varchar(50), 
	@Idsid varchar(25),
	@Wwid varchar(10),
	@Email varchar(255),
	@IsActive bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [qan].[Reviewers]
	(
		 [Name]
		,[Idsid]
		,[Wwid]
		,[Email]
		,[IsActive]
	)
	VALUES
	(
		 @Name
		,@Idsid
		,@Wwid
		,@Email
		,@IsActive
	)
END