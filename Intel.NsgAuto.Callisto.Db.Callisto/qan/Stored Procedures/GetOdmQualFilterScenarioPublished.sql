
-- =============================================
-- Author:		jakemurx
-- Create date: 2021-04-27 16:02:49.163
-- Description:	Get the Odm Qual Filter Scenario that is published
-- =============================================
CREATE PROCEDURE [qan].[GetOdmQualFilterScenarioPublished] 
	-- Add the parameters for the stored procedure here
	@UserId varchar(25),
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	EXEC [qan].[GetOdmQualFilterNonQualifiedMediaReport] @UserId, @Id

	EXEC [qan].[GetOdmQualFilterNonQualifiedMediaExceptions] @UserId, @Id

	EXEC [qan].[GetOdms] @UserId

	UPDATE [qan].[OdmQualFilterScenarios]
	SET [StatusId] = 3
	WHERE [Id] = @Id;

END