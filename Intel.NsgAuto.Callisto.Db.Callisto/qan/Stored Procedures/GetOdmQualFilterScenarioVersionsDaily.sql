



-- =============================================
-- Author:		jakemurx
-- Create date: 2021-03-31 10:57:49.697
-- Description:	Get ODM Qual Filter Scenarios for the current date
-- EXEC [qan].[GetOdmQualFilterScenarioVersionsDaily] 'jakemurx'
-- =============================================
CREATE PROCEDURE [qan].[GetOdmQualFilterScenarioVersionsDaily] 
	-- Add the parameters for the stored procedure here
	  @UserId VARCHAR(25)
	, @Id INT = NULL
	, @PrfVersion INT = NULL
	, @MatVersion INT = NULL
	, @OdmWipSnapshotVersion INT = NULL
	, @LotShipSnapshotVersion INT = NULL
	, @LotDispositionSnapshotVersion INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @Today datetime2(7) = (SELECT DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())));

	SELECT [Id]
		,[PrfVersion]
		,[MatVersion]
		,[OdmWipSnapshotVersion]
		,[LotShipSnapshotVersion]
		,[LotDispositionSnapshotVersion]
		,[DailyId]
		,[StatusId]
		,[CreatedOn]
		,[CreatedBy]
	FROM [qan].[OdmQualFilterScenarios]
	WHERE (@Id IS NULL OR [Id] = @Id)
	  AND (@PrfVersion IS NULL OR [PrfVersion] = @PrfVersion)
	  AND (@MatVersion IS NULL OR [MatVersion] = @MatVersion)
	  AND (@OdmWipSnapshotVersion IS NULL OR [OdmWipSnapshotVersion] = @OdmWipSnapshotVersion)
	  AND (@LotShipSnapshotVersion IS NULL OR [LotShipSnapshotVersion] = @LotShipSnapshotVersion)
	  AND (@LotDispositionSnapshotVersion IS NULL OR [LotDispositionSnapshotVersion] = @LotDispositionSnapshotVersion)
	  AND (DATEADD(dd, 0, DATEDIFF(dd, 0, CreatedOn)) = @Today)
	ORDER BY [DailyId] DESC
END