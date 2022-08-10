
-- =============================================
-- Author:		jakemurx
-- Create date: 2021-03-11 17:01:42.443
-- Description:	Get Odm Wip Snapshot data by scenario Id
-- EXEC [qan].[GetOdmWipSnapshot] 'jkurian', 72
-- =============================================
CREATE PROCEDURE [qan].[GetOdmWipSnapshot] 
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
		  ,[media_lot_id]
		  ,[subcon_name]
		  ,[intel_part_number]
		  ,[location_type]
		  ,[inventory_location]
		  ,[category]
		  ,[mm_number]
		  ,[time_entered]
	  FROM [qan].[OdmWipSnapshots] WITH (NOLOCK)
	WHERE [Version] = @Id
	ORDER BY [Version] DESC;

END