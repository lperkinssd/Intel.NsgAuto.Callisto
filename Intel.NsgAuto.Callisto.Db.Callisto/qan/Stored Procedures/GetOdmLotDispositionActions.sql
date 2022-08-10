

-- =============================================
-- Author:		jakemurx
-- Create date: 2021-04-20 11:37:36.857
-- Description:	Get the list of Lot Disposition actions
-- EXEC [qan].[GetOdmLotDispositionActions] 'jakemurx'
-- =============================================
CREATE PROCEDURE [qan].[GetOdmLotDispositionActions] 
	-- Add the parameters for the stored procedure here
	  @UserId     VARCHAR(25)
	, @Id         INT         = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Id], [ActionName], [DisplayText]
	FROM [ref].[OdmLotDispositionActions]
	WHERE (@Id IS NULL OR [Id] = @Id)

END