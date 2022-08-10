-- ========================================================
-- Author       : bricschx
-- Create date  : 2020-11-10 17:31:20.330
-- Description  : Creates new designs from the speed data
-- Example      : EXEC [qan].[CreateNewSpeedDesigns];
-- ========================================================
CREATE PROCEDURE [qan].[CreateNewSpeedDesigns]
(
	  @CountInserted INT = NULL OUTPUT
	, @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);

	IF (@By IS NULL) SET @By = [qan].[CreatedBySpeed]();

	MERGE [qan].[Products] AS M
	USING
	(
		SELECT S.[Name], DF.[Id] AS [DesignFamilyId] FROM
		(
			SELECT
					[Name]
				, CASE
					WHEN ([DesignedFunctionCode] = 'NAN' OR [DesignedFunctionCode] IS NULL) AND ([MemoryType1] = 'NAND' OR [MemoryType1] IS NULL) THEN 'NAND'
					WHEN ([DesignedFunctionCode] = 'OPT' OR [DesignedFunctionCode] IS NULL) AND ([MemoryType1] = '3DXP' OR [MemoryType1] IS NULL) THEN 'Optane'
					ELSE NULL
					END AS [DesignFamilyName]
			FROM
			(
				SELECT
						[DieCodeName] AS [Name]
					, CASE WHEN [MinDesignedFunctionCode] IS NULL THEN NULL WHEN [MinDesignedFunctionCode] <> [MaxDesignedFunctionCode] THEN NULL ELSE [MinDesignedFunctionCode] END AS [DesignedFunctionCode]
					, CASE WHEN [MinMemoryType1] IS NULL THEN NULL WHEN [MinMemoryType1] <> [MaxMemoryType1] THEN NULL ELSE [MinMemoryType1] END AS [MemoryType1]
				FROM
				(
					SELECT [DieCodeName], MIN([DesignedFunctionCode]) AS [MinDesignedFunctionCode], MAX([DesignedFunctionCode]) AS [MaxDesignedFunctionCode], MIN([MemoryType1]) AS [MinMemoryType1], MAX([MemoryType1]) AS [MaxMemoryType1] FROM [CallistoCommon].[stage].[SpeedDesignItems] WITH (NOLOCK) WHERE [DieCodeName] LIKE '[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]' AND [DieCodeName] <> 'NAND' GROUP BY [DieCodeName]
				) AS T1
			) AS T2
			WHERE [DesignedFunctionCode] IN ('NAN', 'OPT') OR [MemoryType1] IN ('3DXP', 'NAND')
		) AS S
		LEFT OUTER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Name] = S.[DesignFamilyName])
		WHERE S.[DesignFamilyName] IS NOT NULL
	) AS N
	ON (M.[Name] = N.[Name])
	WHEN NOT MATCHED THEN INSERT ([Name], [DesignFamilyId], [IsActive], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], N.[DesignFamilyId], 1, @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @CountInserted = COUNT(*) FROM @Ids;

END
