
-- ============================================================================
-- Author       : bricschx
-- Create date  : 2020-12-29 12:40:02.133
-- Description  : Creates new test flows from the treadstone data
-- Example      : EXEC [qan].[CreateNewTreadstoneTestFlows];
-- ============================================================================
CREATE PROCEDURE [qan].[CreateNewTreadstoneTestFlows]
(
	  @CountInserted INT = NULL OUTPUT
	, @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);

	IF (@By IS NULL) SET @By = [qan].[CreatedByTreadstone]();

	MERGE [qan].[TestFlows] AS M
	USING
	(
		SELECT [Value] As [Name] FROM (SELECT DISTINCT [custom_testing_reqd] AS [Value] FROM [TREADSTONEPRD].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] AS [value] FROM [TREADSTONEPRD].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'custom_testing_reqd') AS T01 WHERE NULLIF(LTRIM(RTRIM([Value])), '') IS NOT NULL AND [Value] != '[No Display Value Assigned]'
		UNION
		SELECT [Value] As [Name] FROM (SELECT DISTINCT [custom_testing_reqd] AS [Value] FROM [TREADSTONENPSG].[treadstone].[dbo].[lot_tracking] WITH (NOLOCK) UNION SELECT DISTINCT [new_value] AS [value] FROM [TREADSTONENPSG].[treadstone].[dbo].[pending_changes_queue] WITH (NOLOCK) WHERE [attribute] = 'custom_testing_reqd') AS T01 WHERE NULLIF(LTRIM(RTRIM([Value])), '') IS NOT NULL AND [Value] != '[No Display Value Assigned]'
	) AS N
	ON (M.[Name] = N.[Name])
	WHEN NOT MATCHED THEN INSERT ([Name], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @CountInserted = COUNT(*) FROM @Ids;

END
