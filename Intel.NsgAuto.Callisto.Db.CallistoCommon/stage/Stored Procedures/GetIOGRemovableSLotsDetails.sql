
-- =====================================================================
-- Author       : ftianx
-- Create date  : 2022-02-24
-- Description  : Gets IOG Removale SLots details information
-- Example      : EXEC [stage].[GetIOGRemovableSLotsDetails] 'ftianx', '02-23-2022'
-- =====================================================================
CREATE PROCEDURE [stage].[GetIOGRemovableSLotsDetails]
(
	@userId VARCHAR(25),
	@version INT,
	@odmName VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;

	;WITH RemovableSLots AS
	(
		SELECT [Version]
			  ,[OdmName]
			  ,[MMNum]
			  ,[DesignId]
			  ,[MediaIPN]
			  ,[SLot]
			  ,[CreateDate]
			  ,[IsRemovable]
			  ,[SourceFileName]
			  ,[ReportedOn] AS [ProcessedOn]
		  FROM [CallistoCommon].[stage].[OdmIOGRemovableSLots]
		  WHERE [Version] = @version
		  AND [OdmName] = @odmName
		  UNION ALL
		SELECT [Version]
			  ,[OdmName]
			  ,[MMNum]
			  ,[DesignId]
			  ,[MediaIPN]
			  ,[SLot]
			  ,[CreateDate]
			  ,[IsRemovable]
			  ,[SourceFileName]
			  ,[ReportedOn] AS [ProcessedOn]
		  FROM [CallistoCommon].[stage].[OdmIOGRemovableSLotsHistory]
		  WHERE [Version] = @version
		  AND [OdmName] = @odmName
	  )

	SELECT * FROM RemovableSLots
	ORDER BY [ProcessedOn] DESC

END