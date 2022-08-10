
-- =============================================
-- Author:		jakemurx
-- Create date: 2021-04-27 15:54:14.250
-- Description:	Get Odm Names
-- EXEC [qan].[GetOdms] ''
-- =============================================
CREATE PROCEDURE [qan].[GetOdms] 
	-- Add the parameters for the stored procedure here
	@UserId varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Id], 
		   [Name] AS 'OdmName'
	FROM [ref].[Odms] WITH (NOLOCK)
	ORDER BY [Name] ASC;

END