
-- =======================================================================
-- Author       : bricschx
-- Create date  : 2020-12-30 15:11:34.867
-- Description  : Creates new attribute types from the treadstone data
-- Example      : EXEC [qan].[CreateNewTreadstoneAttributeTypes];
-- =======================================================================
CREATE PROCEDURE [qan].[CreateNewTreadstoneAttributeTypes]
(
	  @CountInserted INT = NULL OUTPUT
	, @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);

	IF (@By IS NULL) SET @By = [qan].[CreatedByTreadstone]();

	MERGE [qan].[AcAttributeTypes] AS M
	USING
	(
		SELECT [Name], [NameDisplay], CASE WHEN TRY_CAST((SELECT TOP 1 [value] FROM STRING_SPLIT([SampleValues], ',')) AS DECIMAL) IS NOT NULL THEN 2 ELSE 1 END AS [DataTypeId] FROM
		(
			SELECT [column_name] AS [Name], [qan].[TranslateTreadstoneAttributeTypeNameDisplay]([column_name]) AS [NameDisplay], MAX([column_value]) AS [SampleValues] FROM [TREADSTONE].[treadstone].[dbo].[build_rule_condition] WITH (NOLOCK) GROUP BY [column_name]
		) AS S
	) AS N
	ON (M.[Name] = N.[Name])
	WHEN NOT MATCHED THEN INSERT ([Name], [NameDisplay], [DataTypeId], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], N.[NameDisplay], N.[DataTypeId], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @CountInserted = COUNT(*) FROM @Ids;

END