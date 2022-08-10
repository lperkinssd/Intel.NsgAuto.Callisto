-- =====================================================================
-- Author       : ftianx
-- Create date  : 2022-03-22
-- Description  : Gets NPSG Removale SLots upload information
-- Example      : EXEC [stage].[GetQualFilterNPSGRemovableSLotUploads] 'ftianx', '02-23-2022'
-- =====================================================================
CREATE PROCEDURE [stage].[GetQualFilterNPSGRemovableSLotUploads]
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
		FROM [CallistoCommon].[stage].[OdmNPSGRemovableSLots]
		WHERE [ReportedOn] >= @startDate
		AND [ReportedOn] < @endDate
		GROUP BY Version, CreateDate, OdmName, SourceFileName, ReportedOn

		UNION ALL
		SELECT Version, CreateDate, OdmName, SourceFileName, ReportedOn,  SUM(CASE WHEN [IsRemovable] = 'YES' THEN 1 ELSE 0 END) AS RemovableCount, COUNT(IsRemovable) AS TotalCount
		FROM [CallistoCommon].[stage].[OdmNPSGRemovableSLotsHistory]
		WHERE [ReportedOn] >= @startDate
		AND [ReportedOn] < @endDate
		GROUP BY Version, CreateDate, OdmName, SourceFileName, ReportedOn
	)

	SELECT * FROM RemovableSLots
	ORDER BY Version DESC, OdmName

END