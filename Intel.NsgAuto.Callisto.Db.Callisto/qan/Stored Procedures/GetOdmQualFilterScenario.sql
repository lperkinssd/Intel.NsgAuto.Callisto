-- =============================================
-- Author:		jakemurx
-- Create date: 2021-02-25 17:03:00.907
-- Description:	Get ODM Qual Filter Scenario
-- EXEC [qan].[GetOdmQualFilterScenario] 'jakemurx', 61
-- =============================================
CREATE PROCEDURE [qan].[GetOdmQualFilterScenario] 
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
	FROM [qan].[OdmQualFilterScenarios]
	WHERE [Id] = @Id

	EXEC [qan].[GetOdmQualFilterScenarioVersions] @UserId, @Id
	EXEC [qan].[GetOdmPrfVersionDetails] @UserId, @PrfVersion
	EXEC [qan].[GetOdmMatVersionDetails] @UserId, @MatVersion
	EXEC [qan].[GetOdmQualFilterNonQualifiedMediaReport] @UserId, @Id
	EXEC [qan].[GetOdmComparisonLotDisposition] @UserId, @Id
	--EXEC [qan].[GetOdmWipSnapshot] @UserId, @OdmWipSnapshotVersion
	--EXEC [qan].[GetLotShipSnapshot] @UserId, @LotShipSnapshotVersion
	EXEC [qan].[GetOdmLotDispositionReasons] @UserId
	EXEC [qan].[GetOdmQualFilterNonQualifiedMedia] @UserId, @Id
	EXEC [qan].[GetOdmQualFilterNonQualifiedMediaExceptions] @UserId, @Id
	EXEC [qan].[GetOdmLotDispositionActions] @UserId
	EXEC [qan].[GetOdmScenarioInfo] @UserId,  @Id
END