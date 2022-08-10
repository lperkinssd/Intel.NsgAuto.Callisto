
-- ==============================================================
-- Author       : bricschx
-- Create date  : 2020-12-29 12:26:33.860
-- Description  : Creates new designs from the treadstone data
-- Example      : EXEC [qan].[CreateNewTreadstoneDesigns];
-- ==============================================================
CREATE PROCEDURE [qan].[CreateNewTreadstoneDesigns]
(
	  @CountInserted INT = NULL OUTPUT
	, @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);

	IF (@By IS NULL) SET @By = [qan].[CreatedByTreadstone]();

	MERGE [qan].[Products] AS M
	USING
	(
		SELECT S.[Name], DF.[Id] AS [DesignFamilyId] FROM
		(
		 SELECT DISTINCT [design_id] AS [Name], CASE WHEN NULLIF(LTRIM(RTRIM([prb_conv_id])), '') IS NOT NULL THEN 'Optane' ELSE 'NAND' END AS [DesignFamilyName] FROM [TREADSTONE].[treadstone].[dbo].[build_rule] WITH (NOLOCK)
		  UNION
		 SELECT DISTINCT [design_id] AS [Name], CASE WHEN NULLIF(LTRIM(RTRIM([prb_conv_id])), '') IS NOT NULL THEN 'Optane' ELSE 'NAND' END AS [DesignFamilyName] FROM [TREADSTONENPSG].[treadstone].[dbo].[build_rule] WITH (NOLOCK)
		) AS S
		LEFT OUTER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Name] = S.[DesignFamilyName])
		WHERE S.[Name] IS NOT NULL AND S.[DesignFamilyName] IS NOT NULL
	) AS N
	ON (M.[Name] = N.[Name])
	WHEN NOT MATCHED THEN INSERT ([Name], [DesignFamilyId], [IsActive], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], N.[DesignFamilyId], 1, @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @CountInserted = COUNT(*) FROM @Ids;

END
