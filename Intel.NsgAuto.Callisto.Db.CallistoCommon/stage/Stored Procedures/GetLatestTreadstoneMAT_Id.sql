
-- =============================================================
-- Author		: jakemurx
-- Create date	: 2020-09-14 16:22:20.785
-- Description	: Get latest MAT_Id from Treadstone MAT table
--                   EXEC [stage].[GetLatestTreadstoneMAT_Id] @Id
-- =============================================================
CREATE PROCEDURE [stage].[GetLatestTreadstoneMAT_Id] 
	-- Add the parameters for the stored procedure here
	@Id int out 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @Id = (SELECT Top 1 [Mat_Id] 
				  FROM [TREADSTONEPRD].[treadstone].[qan].[MAT] WITH (NOLOCK)
				  ORDER BY [MAT_Id] DESC)
END