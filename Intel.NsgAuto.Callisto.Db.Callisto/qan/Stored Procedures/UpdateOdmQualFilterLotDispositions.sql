-- =============================================
-- Author:		jakemurx
-- Create date: now
-- Description:	Update new Odm Lot Disposition records 
--              with matching previous scenario records
--              that have different LotDispositionReasonId,
--              LotDispositionActionId, or Notes
-- EXEC [qan].[UpdateOdmQualFilterLotDispositions] 'jakemurx', 83
-- =============================================
CREATE PROCEDURE [qan].[UpdateOdmQualFilterLotDispositions] 
	-- Add the parameters for the stored procedure here
	@UserId VARCHAR(25),
	@ScenarioId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PrevScenarioId INT = @ScenarioId - 1;

    -- Insert statements for procedure here
	DECLARE @PrevQualFilters TABLE
	(
		[Id] [int],
		[OdmId] [int] NULL,
		[DesignId] [varchar](200) NULL,
		[SCode] [varchar](200) NULL,
		[MediaIPN] [varchar](200) NULL,
		[SLot] [varchar](200) NULL,
		[OdmQualFilterCategoryId] [int]
	);

	-- The current QdmQualFilters have [OdmQualFilterCategoryId] = 1 Not-Qualified
	-- Look for the previous ones that are marked 2 Qualified
	INSERT INTO @PrevQualFilters
	(
		[Id],
		[OdmId],
		[DesignId],
		[SCode],
		[MediaIPN],
		[SLot],
		[OdmQualFilterCategoryId]
	)
	SELECT
		qf.[Id],
		qf.[OdmId],
		qf.[DesignId],
		qf.[SCode],
		qf.[MediaIPN],
		qf.[SLot],
		qf.[OdmQualFilterCategoryId]
	FROM [qan].[OdmQualFilters] qf
	WHERE	qf.[ScenarioId] = @PrevScenarioId
	AND qf.[OdmQualFilterCategoryId] = 2; -- Qualified

	--SELECT *
	--FROM @PrevQualFilters;

	DECLARE @CurrQualFilters TABLE
	(
		[Id] [int],
		[OdmId] [int] NULL,
		[DesignId] [varchar](200) NULL,
		[SCode] [varchar](200) NULL,
		[MediaIPN] [varchar](200) NULL,
		[SLot] [varchar](200) NULL,
		[OdmQualFilterCategoryId] [int]
	);

	-- Get only the current OdmQualFilters from the current scenario
	-- that match the previous OdmQualFilters on DesignId, MediaIPN,
	-- SCode, SLot, and OdmId
	INSERT INTO @CurrQualFilters
	(
		[Id],
		[OdmId],
		[DesignId],
		[SCode],
		[MediaIPN],
		[SLot],
		[OdmQualFilterCategoryId]
	)
	SELECT
		qf.[Id],
		qf.[OdmId],
		qf.[DesignId],
		qf.[SCode],
		qf.[MediaIPN],
		qf.[SLot],
		pqf.[OdmQualFilterCategoryId] -- This is the previous versions Category Id
	FROM [qan].[OdmQualFilters] qf
	INNER JOIN @PrevQualFilters pqf
		ON qf.DesignId = pqf.DesignId
		AND qf.MediaIPN = pqf.MediaIPN
		AND qf.SCode = pqf.SCode
		AND qf.SLot = pqf.SLot
		AND qf.OdmId = pqf.OdmId
	WHERE qf.[ScenarioId] = @ScenarioId;

	--SELECT *
	--FROM @CurrQualFilters;

	DECLARE @PrevLotDispositions TABLE
	(
		[Id] [int],
		[ScenarioId] [int] NULL,
		[OdmQualFilterId] [int] NOT NULL,
		[LotDispositionReasonId] [int] NOT NULL,
		[Notes] [varchar](max) NULL,
		[LotDispositionActionId] [int] NULL
	);

	-- Get the lot dispositions with the same OdmQualFilterId as the
	-- previous OdmQualFilters
	INSERT INTO @PrevLotDispositions
	(
		[Id],
		[ScenarioId],
		[OdmQualFilterId],
		[LotDispositionReasonId],
		[Notes],
		[LotDispositionActionId]
	)
	SELECT
		ld.[Id],
		ld.[ScenarioId],
		ld.[OdmQualFilterId],
		ld.[LotDispositionReasonId],
		ld.[Notes],
		ld.[LotDispositionActionId]
	FROM [qan].[OdmQualFilterLotDispositions] ld
	INNER JOIN @PrevQualFilters pqf
		ON ld.[OdmQualFilterId] = pqf.[Id];

	--SELECT *
	--FROM @PrevLotDispositions;

	DECLARE @CurrLotDispositions TABLE
	(
		[Id] [int],
		[ScenarioId] [int] NULL,
		[OdmQualFilterId] [int] NOT NULL,
		[LotDispositionReasonId] [int] NOT NULL,
		[Notes] [varchar](max) NULL,
		[LotDispositionActionId] [int] NULL
	);

	-- Get the current lot dispositions that match the current
	-- OdmQualFilters on the lot disposition OdmQualFilterId = OdmQualFilters Id
	INSERT INTO @CurrLotDispositions
	(
		[Id],
		[ScenarioId],
		[OdmQualFilterId],
		[LotDispositionReasonId],
		[Notes],
		[LotDispositionActionId]
	)
	SELECT
		ld.[Id],
		ld.[ScenarioId],
		ld.[OdmQualFilterId],
		ld.[LotDispositionReasonId],
		ld.[Notes],
		ld.[LotDispositionActionId]
	FROM [qan].[OdmQualFilterLotDispositions] ld
	INNER JOIN @CurrQualFilters cqf
		ON ld.[OdmQualFilterId] = cqf.[Id];

	--SELECT *
	--FROM @CurrLotDispositions;

	UPDATE [qan].[OdmQualFilters]
	SET [OdmQualFilterCategoryId] = cqf.[OdmQualFilterCategoryId] -- This is the previous versions Category Id
	FROM [qan].[OdmQualFilters] qf
	INNER JOIN  @CurrQualFilters cqf
		ON qf.[Id] = cqf.[Id];

	DECLARE @IdNumbers TABLE
	(
		[CurrId] int,
		[PrevId] int,
		[OdmId] [int] NULL,
		[DesignId] [varchar](200) NULL,
		[SCode] [varchar](200) NULL,
		[MediaIPN] [varchar](200) NULL,
		[SLot] [varchar](200) NULL
	);

	-- Get the previous OdmQualFilters Ids and the current OdmQualFilters Ids
	-- along with the matching DesignId, MediaIPN, SCode, SLot, and OdmId
	INSERT INTO @IdNumbers
	(
		[CurrId],
		[PrevId],
		[OdmId],
		[DesignId],
		[SCode],
		[MediaIPN],
		[SLot]
	)
	SELECT
		qf.[Id],
		pqf.[Id],
		pqf.[OdmId],
		pqf.[DesignId],
		pqf.[SCode],
		pqf.[MediaIPN],
		pqf.[SLot]
	FROM @CurrQualFilters qf
	INNER JOIN @PrevQualFilters pqf
		ON qf.DesignId = pqf.DesignId
		AND qf.MediaIPN = pqf.MediaIPN
		AND qf.SCode = pqf.SCode
		AND qf.SLot = pqf.SLot
		AND qf.OdmId = pqf.OdmId;

	--SELECT *
	--FROM @IdNumbers;

	UPDATE [qan].[OdmQualFilterLotDispositions]
	SET [LotDispositionReasonId] = plf.[LotDispositionReasonId],
		[LotDispositionActionId] = plf.[LotDispositionActionId],
		[Notes] = plf.[Notes]
	FROM [qan].[OdmQualFilterLotDispositions] qfld
		INNER JOIN @IdNumbers idn
			ON qfld.[Id] = idn.[CurrId]
		INNER JOIN @PrevLotDispositions plf
			ON idn.[PrevId] = plf.[Id]

END