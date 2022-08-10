-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-01-29 16:32:39.203
-- Description  : Gets OSAT PAS version records
-- Example      : SELECT * FROM [qan].[FOsatPasVersionRecords](NULL, 1, NULL);
-- ============================================================================
CREATE FUNCTION [qan].[FOsatPasVersionRecords]
(
	  @Id            BIGINT  = NULL
	, @VersionId     INT     = NULL
	, @RecordNumber  INT     = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  R.[Id]
		, R.[VersionId]
		, R.[RecordNumber]
		, R.[ProductGroup]
		, R.[Project]
		, R.[IntelProdName]
		, R.[IntelLevel1PartNumber]
		, R.[Line1TopSideMarking]
		, R.[CopyrightYear]
		, R.[SpecNumberField]
		, R.[MaterialMasterField]
		, R.[MaxQtyPerMedia]
		, R.[Media]
		, R.[RoHsCompliant]
		, R.[LotNo]
		, R.[FullMediaReqd]
		, R.[SupplierPartNumber]
		, R.[IntelMaterialPn]
		, R.[TestUpi]
		, R.[PgTierAndSpeedInfo]
		, R.[AssyUpi]
		, R.[DeviceName]
		, R.[Mpp]
		, R.[SortUpi]
		, R.[ReclaimUpi]
		, R.[ReclaimMm]
		, R.[ProductNaming]
		, R.[TwoDidApproved]
		, R.[TwoDidStartedWw]
		, R.[Did]
		, R.[Group]
		, R.[Note]
	FROM [qan].[OsatPasVersionRecords] AS R WITH (NOLOCK)
	WHERE (@Id IS NULL OR R.[Id] = @Id)
	  AND (@VersionId IS NULL OR R.[VersionId] = @VersionId)
	  AND (@RecordNumber IS NULL OR R.[RecordNumber] = @RecordNumber)
)
