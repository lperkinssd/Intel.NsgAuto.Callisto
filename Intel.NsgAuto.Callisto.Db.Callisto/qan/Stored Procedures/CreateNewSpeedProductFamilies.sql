-- ====================================================================
-- Author       : bricschx
-- Create date  : 2020-09-29 18:37:31.417
-- Description  : Creates new product families from the speed data
-- Example      : EXEC [qan].[CreateNewSpeedProductFamilies]
-- ====================================================================
CREATE PROCEDURE [qan].[CreateNewSpeedProductFamilies]
(
	  @CountInserted INT = NULL OUTPUT
	, @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);

	IF (@By IS NULL) SET @By = [qan].[CreatedBySpeed]();

	MERGE [qan].[ProductFamilies] AS M
	USING (SELECT DISTINCT [Name] FROM [CallistoCommon].[stage].[VSpeedProductFamilies] WITH (NOLOCK) WHERE NULLIF(RTRIM(LTRIM([Name])), '') IS NOT NULL) AS N
	ON (M.[NameSpeed] = N.[Name])
	WHEN NOT MATCHED THEN INSERT ([Name], [NameSpeed], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], N.[Name], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @CountInserted = COUNT(*) FROM @Ids;

END
