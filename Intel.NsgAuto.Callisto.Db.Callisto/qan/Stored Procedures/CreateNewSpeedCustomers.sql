-- ==============================================================
-- Author       : bricschx
-- Create date  : 2020-09-29 18:21:51.763
-- Description  : Creates new customers from the speed data
-- Example      : EXEC [qan].[CreateNewSpeedCustomers]
-- ==============================================================
CREATE PROCEDURE [qan].[CreateNewSpeedCustomers]
(
	  @CountInserted INT = NULL OUTPUT
	, @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);

	IF (@By IS NULL) SET @By = [qan].[CreatedBySpeed]();

	MERGE [qan].[Customers] AS M
	USING (SELECT DISTINCT [Name] FROM [CallistoCommon].[stage].[VSpeedCustomers] WITH (NOLOCK) WHERE NULLIF(RTRIM(LTRIM([Name])), '') IS NOT NULL) AS N
	ON (M.[NameSpeed] = N.[Name])
	WHEN NOT MATCHED THEN INSERT ([Name], [NameSpeed], [CreatedBy], [UpdatedBy]) VALUES ([qan].[TranslateSpeedCustomer](N.[Name]), N.[Name], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @CountInserted = COUNT(*) FROM @Ids;

END
