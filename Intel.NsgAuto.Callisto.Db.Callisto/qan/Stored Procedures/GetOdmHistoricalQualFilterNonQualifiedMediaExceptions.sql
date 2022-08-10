

-- ==================================================================================================================================================
-- Author       : ftianx (modified based on [qan].[GetOdmQualFilterNonQualifiedMediaExceptions])
-- Create date  : 2021-11-03 10:58:58.698
-- Description  : Get the historical non-qualified media exceptions
-- Example      : EXEC [qan].[GetOdmHistoricalQualFilterNonQualifiedMediaExceptions] 'fuhantx', 15
-- ==================================================================================================================================================

CREATE PROCEDURE [qan].[GetOdmHistoricalQualFilterNonQualifiedMediaExceptions] 
	@UserId varchar(25), 
	@Id int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @qualified INT = (SELECT Id FROM [ref].[OdmQualFilterCategories] WITH (NOLOCK) WHERE [Name] = 'Qualified')
	DECLARE @MatVersion INT = (SELECT [MatVersion] FROM [qan].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE [Id] = @Id);
	DECLARE @Exceptions TABLE
	(
		[ScenarioId] INT,
		[OdmId] INT,
		[OdmName] VARCHAR(255),
		[ScodeMm] VARCHAR(25),
		[MediaIpn] VARCHAR(25),
		[SLot] VARCHAR(25)
	);

	INSERT INTO @Exceptions
	(
		[ScenarioId],
		[OdmId],
		[ScodeMm],
		[MediaIpn],
		[SLot]
	)
	SELECT [ScenarioId]
		  ,[OdmId]
		  ,[SCode] AS [ScodeMm]
		  ,[MediaIPN] AS [MediaIpn]
		  ,[SLot]
	FROM [qan].[OdmQualFiltersHistory]
	WHERE [ScenarioId] = @Id
	AND [OdmQualFilterCategoryId] = @qualified

	SELECT 
		  ex.[ScenarioId]
		, ex.OdmId
		, o.[Name] as 'OdmName'
		, ex.[ScodeMm]
		, ex.[MediaIpn]
		, ex.SLot
		, m.SSD_Id
		, m.Design_Id
		, m.Device_Name
		, m.Media_Type
	FROM @Exceptions ex
		INNER JOIN [qan].[MAT] m  WITH (NOLOCK) 
		ON ex.[ScodeMm] = m.[Scode]
			AND ex.[MediaIpn] = m.[Media_IPN]
		INNER JOIN [ref].[Odms] o  WITH (NOLOCK) 
		ON ex.[OdmId] = o.[Id]
	WHERE m.[MatVersion] = @MatVersion;

END