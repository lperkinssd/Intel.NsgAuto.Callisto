
-- ============================================================================
-- Author       : bricschx
-- Create date  : 2020-12-29 12:35:31.270
-- Description  : Creates new fabrication facilities from the treadstone data
-- Example      : EXEC [qan].[CreateNewTreadstoneFabricationFacilities];
-- ============================================================================
CREATE PROCEDURE [qan].[CreateNewTreadstoneFabricationFacilities]
(
	  @CountInserted INT = NULL OUTPUT
	, @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);

	IF (@By IS NULL) SET @By = [qan].[CreatedByTreadstone]();

	MERGE [qan].[FabricationFacilities] AS M
	USING
	(
		SELECT [Value] As [Name] FROM (SELECT DISTINCT [fabrication_facility] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'fabrication_facility') AS T01 WHERE NULLIF(LTRIM(RTRIM([Value])), '') IS NOT NULL
		UNION
		SELECT [Value] As [Name] FROM (SELECT DISTINCT [fabrication_facility] COLLATE SQL_Latin1_General_CP1_CS_AS AS [Value] FROM [TREADSTONENPSG].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] COLLATE SQL_Latin1_General_CP1_CS_AS AS [value] FROM [TREADSTONENPSG].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'fabrication_facility') AS T01 WHERE NULLIF(LTRIM(RTRIM([Value])), '') IS NOT NULL
	) AS N
	ON (M.[Name] = N.[Name])
	WHEN NOT MATCHED THEN INSERT ([Name], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @CountInserted = COUNT(*) FROM @Ids;

END
