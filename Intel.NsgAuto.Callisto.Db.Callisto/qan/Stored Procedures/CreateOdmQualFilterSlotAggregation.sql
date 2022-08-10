-- =============================================
-- Author:		jakemurx
-- Create date: 2021-04-23 15:34:15.617
-- Description:	Create an aggregation of Odm Qual Filter non-qualified SLots
-- =============================================
CREATE PROCEDURE [qan].[CreateOdmQualFilterSlotAggregation] 
	-- Add the parameters for the stored procedure here
	@UserId VARCHAR(25),
	@ScenarioId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @MatVersion INT;
	DECLARE @PrfVersion INT;
	DECLARE @OdmId INT;
	DECLARE @OdmName  VARCHAR(100);

	SELECT
		 @MatVersion = [MatVersion]
		,@PrfVersion = [PrfVersion]
	FROM [qan].[OdmQualFilterScenarios] WITH (NOLOCK)
	WHERE [Id] = @ScenarioId;

	DECLARE OdmCursor CURSOR FOR
	SELECT [Id], [Name]
	FROM [ref].[Odms];

	OPEN OdmCursor
	FETCH NEXT FROM OdmCursor INTO @OdmId, @OdmName

	WHILE @@FETCH_STATUS = 0
	BEGIN

		DECLARE @ConcatString VARCHAR(MAX)
		DECLARE @DesignId VARCHAR(50), @Scode VARCHAR(50), @MediaIPN VARCHAR(50)
		DECLARE @QualFilterFinal TABLE ( Scode VARCHAR(50), MediaIPN VARCHAR(50), OdmName VARCHAR(50), DesignId VARCHAR(50), SLots VARCHAR (MAX), MatId INT, PrfId INT, CreatedOn DATETIME) -- Use DATETIME or datetime2(7)

		DECLARE QfCursor CURSOR FOR 
		SELECT DISTINCT SCode, MediaIPN, DesignId
		FROM qan.OdmQualFilters
		WHERE ScenarioId=@ScenarioId
		AND OdmId=@OdmId

		OPEN QfCursor
		FETCH NEXT FROM QfCursor INTO @Scode, @MediaIPN, @DesignId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @ConcatString = COALESCE (@ConcatString + ';' ,'') + SLot 
			FROM [qan].[OdmQualFilters] WITH (NOLOCK)
			WHERE [ScenarioId] = @ScenarioId
			AND OdmId=@OdmId
			AND SCode = @Scode
			AND MediaIPN =@MediaIPN
			AND OdmQualFilterCategoryId = 1; -- Non Qualified

			-- Check if the string begins with a semi-colon. Remove if found
			IF CHARINDEX(';', @ConcatString) = 1
			BEGIN
				SET @ConcatString = (SELECT RIGHT(@ConcatString, LEN(@ConcatString) -1))
			END

			INSERT INTO @QualFilterFinal VALUES ( @Scode, @MediaIPN, @OdmName ,@DesignId, @ConcatString, @MatVersion, @PrfVersion, CURRENT_TIMESTAMP) -- Use this or GETUTCDATE()?            

			SET @ConcatString = '';

			FETCH NEXT FROM QfCursor INTO @Scode, @MediaIPN, @DesignId
		END
		CLOSE QfCursor
		DEALLOCATE QfCursor

		FETCH NEXT FROM OdmCursor INTO @OdmId, @OdmName
	END
	CLOSE OdmCursor
	DEALLOCATE OdmCursor

	INSERT INTO [qan].[OdmQualFilterNonQualifiedMediaReport]
	(
		 [ScenarioId]
		,[MMNum]
		,[OdmName]
		,[DesignId]
		,[SLots]
		,[MatId]
		,[PrfId]
		,[OsatIpn]
		,[CreatedBy]
		,[CreatedOn]
	)
	
	SELECT 
		  @ScenarioId
		, Scode AS [MMNum]
		, OdmName
		, DesignId
		, SLots
		, MatId
		, PrfId
		, MediaIPN AS [OsatIpn]
		, @UserId AS [CreatedBy]
		, CreatedOn 
	FROM @QualFilterFinal
END