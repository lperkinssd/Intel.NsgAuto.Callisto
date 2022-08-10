


-- =============================================
-- Author:		jakemurx
-- Create date: now
-- Description:	Get the non-qualified media exceptions
-- Note: Added the UNION section to include any record that is in the OdmQualFilterLotDispositions
-- EXEC [npsg].[GetOdmQualFilterNonQualifiedMediaExceptions] 'jakemurx', 1
-- =============================================
CREATE PROCEDURE [npsg].[GetOdmQualFilterNonQualifiedMediaExceptions] 
	-- Add the parameters for the stored procedure here
	@UserId varchar(25), 
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	DECLARE @MatVersion INT = (SELECT [MatVersion] FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK) WHERE [Id] = @Id);
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
	----SELECT [ScenarioId]
	----	  ,[OdmId]
	----	  ,[SCodeMMNumber] AS [ScodeMm]
	----	  ,[MediaIPN] AS [MediaIpn]
	----	  ,[SLot]
	----FROM [npsg].[OdmQualFilterNonQualifiedMediaExceptions]
	----WHERE [ScenarioId] = @Id

	----UNION

	SELECT [ScenarioId]
		  ,[OdmId]
		  ,[SCode] AS [ScodeMm]
		  ,[MediaIPN] AS [MediaIpn]
		  ,[SLot]
	FROM [npsg].[OdmQualFilters]
	WHERE [ScenarioId] = @Id
	AND [OdmQualFilterCategoryId] = 2 -- Qualified

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
		INNER JOIN [npsg].[MAT] m  WITH (NOLOCK) 
		ON ex.[ScodeMm] = m.[Scode]
			AND ex.[MediaIpn] = m.[Media_IPN]
		INNER JOIN [ref].[Odms] o  WITH (NOLOCK) 
		ON ex.[OdmId] = o.[Id]
	WHERE m.[MatVersion] = @MatVersion;

END