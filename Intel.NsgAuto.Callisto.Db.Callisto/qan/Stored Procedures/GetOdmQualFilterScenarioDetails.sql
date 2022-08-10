-- =============================================
-- Author:		jakemurx
-- Create date: 2021-03-02 13:06:22.560
-- Description:	Get ODM Qual Filter Scenario details
-- EXEC [qan].[GetOdmQualFilterScenarioDetails] 'jakemurx', 2
-- =============================================
CREATE PROCEDURE [qan].[GetOdmQualFilterScenarioDetails] 
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
			@LotDispositionSnapshotVersion INT,
			@CreatedBy VARCHAR(25),
			@CreatedOn datetime2(7)

	SELECT
		 @PrfVersion = [PrfVersion]
		,@MatVersion = [MatVersion]
		,@OdmWipSnapshotVersion = [OdmWipSnapshotVersion]
		,@LotShipSnapshotVersion = [LotShipSnapshotVersion]
		,@LotDispositionSnapshotVersion = [LotDispositionSnapshotVersion]
		,@CreatedBy = [CreatedBy]
		,@CreatedOn = [CreatedOn]
	FROM [qan].[OdmQualFilterScenarios]
	WHERE [Id] = @Id

	SELECT  @Id AS 'Id',
			@PrfVersion AS 'PrfVersion', 
			@MatVersion AS 'MatVersion', 
			@OdmWipSnapshotVersion AS 'OdmWipSnapshotVersion',
			@LotShipSnapshotVersion AS 'LotShipSnapshotVersion',
			@LotDispositionSnapshotVersion AS 'LotDispositionSnapshotVersion',
			@CreatedBy AS 'CreatedBy',
			@CreatedOn AS 'CreatedOn'

	EXEC [qan].[GetOdmPrfVersionDetails] @UserId, @PrfVersion
	EXEC [qan].[GetOdmMatVersionDetails] @UserId, @MatVersion
	EXEC [qan].[GetOdmQualFilterData] @UserId
END