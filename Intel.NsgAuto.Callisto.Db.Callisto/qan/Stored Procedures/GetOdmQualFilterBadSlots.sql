-- =============================================
-- Author:		jakemurx
-- Create date: 2021-03-15 09:10:40.333
-- Description:	Get Odm Qual Filter Bad Slots by version
-- EXEC [qan].[GetOdmQualFilterBadSlots]  'jakemurx', 12
-- =============================================
CREATE PROCEDURE [qan].[GetOdmQualFilterBadSlots] 
	-- Add the parameters for the stored procedure here
	@UserId varchar(25), 
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Version]
		  ,[MediaLotId]
	  FROM [qan].[OdmQualFilterBadSlots]
	WHERE [Version] = @Id
	ORDER BY [MediaLotId]
END