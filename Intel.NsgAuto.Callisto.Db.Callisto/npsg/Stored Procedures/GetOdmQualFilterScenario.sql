-- =============================================
-- Author:		jakemurx
-- Create date: 2021-02-25 17:03:00.907
-- Description:	Get ODM Qual Filter Scenario
-- EXEC [npsg].[GetOdmQualFilterScenario] 'jakemurx', 61
-- =============================================
CREATE PROCEDURE [npsg].[GetOdmQualFilterScenario] 
	-- Add the parameters for the stored procedure here
	@UserId VARCHAR(25), 
	@Id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @PrfVersion INT,
			@MatVersion INT,
			@OdmWipSnapshotVersion INT,
			@LotShipSnapshotVersion INT,
			@LotDispositionSnapshotVersion INT

	SELECT
		 @PrfVersion = [PrfVersion]
		,@MatVersion = [MatVersion]
		,@OdmWipSnapshotVersion = [OdmWipSnapshotVersion]
		,@LotShipSnapshotVersion = [LotShipSnapshotVersion]
		,@LotDispositionSnapshotVersion = [LotDispositionSnapshotVersion]
	FROM [npsg].[OdmQualFilterScenarios]
	WHERE [Id] = @Id

	EXEC [npsg].[GetOdmQualFilterScenarioVersions] @UserId, @Id
	EXEC [npsg].[GetOdmPrfVersionDetails] @UserId, @PrfVersion
	EXEC [npsg].[GetOdmMatVersionDetails] @UserId, @MatVersion
	EXEC [npsg].[GetOdmQualFilterNonQualifiedMediaReport] @UserId, @Id
	EXEC [npsg].[GetOdmComparisonLotDisposition] @UserId, @Id
	--EXEC [npsg].[GetOdmWipSnapshot] @UserId, @OdmWipSnapshotVersion
	--EXEC [npsg].[GetLotShipSnapshot] @UserId, @LotShipSnapshotVersion
	EXEC [npsg].[GetOdmLotDispositionReasons] @UserId
	EXEC [npsg].[GetOdmQualFilterNonQualifiedMedia] @UserId, @Id
	EXEC [npsg].[GetOdmQualFilterNonQualifiedMediaExceptions] @UserId, @Id
	EXEC [npsg].[GetOdmLotDispositionActions] @UserId
	EXEC [npsg].[GetOdmScenarioInfo] @UserId,  @Id
END