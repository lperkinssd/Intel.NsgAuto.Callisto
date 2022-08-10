-- =============================================
-- Author:		jakemurx
-- Create date: 2021-03-22 15:35:53.497
-- Description:	Create a copy of Lot Dispositions for the new scenario
-- =============================================
CREATE PROCEDURE [qan].[CreateOdmQualFilterLotDispositionsNewScenario] 
	-- Add the parameters for the stored procedure here
	@UserId varchar(25), 
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @PreviousId int
	SET @PreviousId = @Id - 1

	IF OBJECT_ID('tempdb..#Comparison') IS NOT NULL  DROP TABLE #Comparison
	IF OBJECT_ID('tempdb..#PreviousLotDispositions') IS NOT NULL  DROP TABLE #PreviousLotDispositions
	IF OBJECT_ID('tempdb..#IdNumbers') IS NOT NULL  DROP TABLE #IdNumbers

	CREATE TABLE #Comparison
	(
		 [Id] int
		,[SSD_Id] varchar(255)
		,[SubConName] varchar(255)
		,[InventoryLocation] varchar(255)
		,[MMNumber] varchar(255)
		,[LocationType] varchar(255)
		,[Category] varchar(255)
		,[SLot] varchar(255)
		,[SCode] varchar(255)
		,[MediaIPN] varchar(255)
		,[PorMajorProbeProgramRevision] varchar(255)
		,[ActualMajorProbeProgramRevision] varchar(255)
		,[PorBurnTapeRevision] varchar(255)
		,[ActualBurnTapeRevision] varchar(255)
		,[PorCellRevision] varchar(255)
		,[ActualCellRevision] varchar(255)
		,[PorCustomTestingRequired] varchar(255)
		,[ActualCustomTestingRequired] varchar(255)
		,[PorFabConvId] varchar(255)
		,[ActualFabConvId] varchar(255)
		,[PorFabExcrId] varchar(255)
		,[ActualFabExcrId] varchar(255)
		,[PorProductGrade] varchar(255)
		,[ActualProductGrade] varchar(255)
		,[PorReticleWaveId] varchar(255)
		,[ActualReticleWaveId] varchar(255)
		,[PorFabFacility] varchar(255)
		,[ActualFabFacility] varchar(255)
		,[PorProbeRev] varchar(255)
		,[ActualProbeRev] varchar(255)
		,[LotDispositionReasonId] int
		,[LotDispositionReason] varchar(255)
		,[Notes] varchar(MAX)
		,[LotDispositionActionId] int
		,[LotDispositionActionName] varchar(255)
		,[LotDispositionDisplayText] varchar(255)
	)

	INSERT #Comparison exec [qan].[GetOdmComparisonLotDisposition] @UserId, @PreviousId

	SELECT c.[Id], c.[SLot], c.[SCode], c.[MediaIPN] INTO #PreviousLotDispositions
	FROM #Comparison c
	INNER JOIN [qan].[OdmQualFilterLotDispositions] qfld ON c.[Id] = qfld.[OdmQualFilterId]

	TRUNCATE TABLE #Comparison

	INSERT #Comparison exec [qan].[GetOdmComparisonLotDisposition] @UserId, @Id

	SELECT c.[Id], p.[Id] AS 'Previous' INTO #IdNumbers
	FROM #Comparison c
	INNER JOIN #PreviousLotDispositions p ON 
	c.[SLot] = p.[SLot] AND
	c.[SCode] = p.[SCode] AND
	c.[MediaIPN] = p.[MediaIPN]

	INSERT INTO [qan].[OdmQualFilterLotDispositions]
	SELECT @Id, i.[Id], l.[LotDispositionReasonId], l.[Notes], l.[LotDispositionActionId], GETDATE(), @UserId, GETDATE(), @UserId
	FROM [qan].[OdmQualFilterLotDispositions] l
	INNER JOIN #IdNumbers i ON l.[OdmQualFilterId] = i.[Previous]

END