-- =====================================================================
-- Author       : ftianx
-- Create date  : 02-23-2022
-- Description  : Get IOG Removale SLots upload information
-- Example      : EXEC [stage].[GetQualFilterIOGRemovableSLotUploads] 'ftianx', '02-23-2022'
-- =====================================================================
CREATE PROCEDURE [stage].[GetQualFilterIOGRemovableSLotUploads]
(
	  @userId VARCHAR(25)
	, @loadToDate DateTime2
)
AS
BEGIN
	SET NOCOUNT ON;

	--Only load data 120 days back
	DECLARE @startDate DATETIME2 = DATEADD(DAY, -120, @loadToDate)
	DECLARE @endDate DATETIME2 = DATEADD(DAY, 1, @loadToDate)

	;WITH RemovableSLots AS
	(
		SELECT Version, CreateDate, OdmName, SourceFileName, ReportedOn,  SUM(CASE WHEN [IsRemovable] = 'YES' THEN 1 ELSE 0 END) AS RemovableCount, COUNT(IsRemovable) AS TotalCount
		FROM [CallistoCommon].[stage].[OdmIOGRemovableSLots]
		WHERE [ReportedOn] >= @startDate
		AND [ReportedOn] < @endDate
		GROUP BY Version, CreateDate, OdmName, SourceFileName, ReportedOn

		UNION ALL
		SELECT Version, CreateDate, OdmName, SourceFileName, ReportedOn,  SUM(CASE WHEN [IsRemovable] = 'YES' THEN 1 ELSE 0 END) AS RemovableCount, COUNT(IsRemovable) AS TotalCount
		FROM [CallistoCommon].[stage].[OdmIOGRemovableSLotsHistory]
		WHERE [ReportedOn] >= @startDate
		AND [ReportedOn] < @endDate
		GROUP BY Version, CreateDate, OdmName, SourceFileName, ReportedOn
	)

	SELECT * FROM RemovableSLots
	ORDER BY Version DESC, OdmName

END