
-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-02 16:22:25.654
-- Description:	Get statuses
--         EXEC [qan].[GetStatuses] 
-- =============================================
CREATE PROCEDURE [qan].[GetStatuses] 
	-- Add the parameters for the stored procedure here
	@UserId varchar(25),
	@Id int = null, 
	@Name varchar(25) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		 [Id]
		,LTRIM(RTRIM([Name])) AS [Name]
	FROM [ref].[Statuses] WITH (NOLOCK)
	WHERE (@Id IS NULL OR [Id] = @Id) 
	AND (@Name IS NULL OR LTRIM(RTRIM([Name])) = @Name)
	ORDER BY [Name]
END