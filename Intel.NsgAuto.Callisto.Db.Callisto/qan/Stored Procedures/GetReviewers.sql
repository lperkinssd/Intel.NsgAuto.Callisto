
-- =============================================
-- Author:		jakemurx
-- Create date: 2020-09-30 14:13:18.871
-- Description:	Get reviewers
-- =============================================
CREATE PROCEDURE [qan].[GetReviewers]
	-- Add the parameters for the stored procedure here
	@Id int = null, 
	@Name varchar(50) = null,
	@Idsid varchar(50) = null,
	@WWID varchar(10) = null,
	@Email varchar(255) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Id]
		  ,LTRIM(RTRIM([Name])) AS [Name]
		  ,LTRIM(RTRIM([Idsid])) AS [Idsid]
		  ,LTRIM(RTRIM([Wwid])) AS [WWID]
		  ,LTRIM(RTRIM([Email])) AS [Email]
		  ,[IsActive]
	  FROM [qan].[Reviewers] WITH (NOLOCK) 
	  WHERE (@Id IS NULL OR @Id = [Id]) 
	  AND (@Name IS NULL OR @Name = [Name]) 
	  AND (@Idsid IS NULL OR @Idsid = [Idsid]) 
	  AND (@WWID IS NULL OR @WWID = [Wwid])
	  AND (@Email IS NULL OR @Email = [Email])
END