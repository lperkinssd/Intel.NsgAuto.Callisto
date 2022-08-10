-- ==============================================================
-- Author       : bricschx
-- Create date  : 2020-10-07 09:29:10.230
-- Description  : Creates new form factors from the speed data
-- Example      : EXEC [qan].[CreateNewSpeedFormFactors]
-- ==============================================================
CREATE PROCEDURE [qan].[CreateNewSpeedFormFactors]
(
	  @CountInserted INT = NULL OUTPUT
	, @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);

	IF (@By IS NULL) SET @By = [qan].[CreatedBySpeed]();

	MERGE [qan].[FormFactors] AS M
	USING (SELECT DISTINCT [Name] FROM [CallistoCommon].[stage].[VSpeedFormFactors] WITH (NOLOCK) WHERE NULLIF(RTRIM(LTRIM([Name])), '') IS NOT NULL) AS N
	ON (M.[NameSpeed] = N.[Name])
	WHEN NOT MATCHED THEN INSERT ([Name], [NameSpeed], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], N.[Name], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @CountInserted = COUNT(*) FROM @Ids;

END
