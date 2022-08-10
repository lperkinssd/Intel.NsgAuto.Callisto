-- ====================================================================
-- Author       : bricschx
-- Create date  : 2020-10-09 10:32:50.590
-- Description  : Creates new bom association types from the speed data
-- Example      : EXEC [qan].[CreateNewSpeedBomAssociationTypes]
-- ====================================================================
CREATE PROCEDURE [qan].[CreateNewSpeedBomAssociationTypes]
(
	  @CountInserted INT = NULL OUTPUT
	, @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);

	IF (@By IS NULL) SET @By = [qan].[CreatedBySpeed]();

	MERGE [qan].[SpeedBomAssociationTypes] AS M
	USING (SELECT DISTINCT [Code], [Name] FROM [CallistoCommon].[stage].[VSpeedBomAssociationTypes] WITH (NOLOCK)) AS N
	ON (M.[CodeSpeed] = N.[Code])
	WHEN NOT MATCHED THEN INSERT ([Name], [NameSpeed], [CodeSpeed], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], N.[Name], N.[Code], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @CountInserted = COUNT(*) FROM @Ids;

END
