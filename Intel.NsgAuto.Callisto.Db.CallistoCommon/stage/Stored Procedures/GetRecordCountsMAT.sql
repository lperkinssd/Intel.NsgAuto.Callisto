
-- =============================================
-- Author:		jakemurx
-- Create date: 2020-09-16 12:51:43.715
-- Description:	Get record counts between MAT tables
--              EXEC [stage].[GetRecordCountsMAT] 
-- =============================================
CREATE PROCEDURE [stage].[GetRecordCountsMAT] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT COUNT(*) AS [Current]
	FROM [stage].[MAT] WITH (NOLOCK)

	SELECT COUNT(*) AS [Previous]
	FROM [stage].[MAT_Previous] WITH (NOLOCK)

END