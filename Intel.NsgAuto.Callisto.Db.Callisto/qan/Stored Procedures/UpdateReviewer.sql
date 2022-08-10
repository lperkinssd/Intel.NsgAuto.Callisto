-- =============================================
-- Author:		jakemurx
-- Create date: 2020-09-30 14:43:45.941
-- Description:	Update a reviewer
-- =============================================
CREATE PROCEDURE [qan].[UpdateReviewer]
	-- Add the parameters for the stored procedure here
	@Id int, 
	@Name varchar(50),
	@Idsid varchar(50),
	@WWID varchar(10),
	@Email varchar(255),
	@IsActive bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [qan].[Reviewers]
	SET [Name] = @Name,
		[Idsid] = @Idsid,
		[Wwid] = @WWID,
		[Email] = @Email,
		[IsActive] = @IsActive
	WHERE [Id] = @Id
END