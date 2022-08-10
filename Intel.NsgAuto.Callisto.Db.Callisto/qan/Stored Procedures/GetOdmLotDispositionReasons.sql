
-- =============================================
-- Author:		jakemurx
-- Create date: 2021-04-07 15:03:20.820
-- Description:	Get the list of Lot Disposition reasons
-- EXEC [qan].[GetOdmLotDispositionReasons] 'jakemurx'
-- =============================================
CREATE PROCEDURE [qan].[GetOdmLotDispositionReasons] 
	-- Add the parameters for the stored procedure here
	  @UserId     VARCHAR(25)
	, @Id         INT         = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Id], [Description]
	FROM [ref].[OdmLotDispositionReasons]
	WHERE (@Id IS NULL OR [Id] = @Id)

END