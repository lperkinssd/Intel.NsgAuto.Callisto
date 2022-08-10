-- ==============================================================================
-- Author       : bricschx
-- Create date  : 2020-09-23 17:25:07.143
-- Description  : Gets item detail v2 records
-- Example      : EXEC [stage].[GetItemDetailV2Records] 'bricschx', NULL, 'PCODE'
-- ==============================================================================
CREATE   PROCEDURE [stage].[GetItemDetailV2Records]
(
	  @UserId VARCHAR(25)
	, @ItemId NVARCHAR(21) = NULL
	, @RecordType VARCHAR(20) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		  [PullDateTime]
		, [ItemId]
		, [ItemDsc]
		, [ItemFullDsc]
		, [CommodityCd]
		, [ItemClassNm]
		, [ItemRevisionId]
		, [EffectiveRevisionCd]
		, [CurrentRevisionCd]
		, [ItemOwningSystemNm]
		, [MakeBuyNm]
		, [NetWeightQty]
		, [UnitOfMeasureCd]
		, [MaterialTypeCd]
		, [GrossWeightQty]
		, [UnitOfWeightDim]
		, [GlobalTradeIdentifierNbr]
		, [BusinessUnitId]
		, [BusinessUnitNm]
		, [LastClassChangeDt]
		, [OwningSystemLastModificationDtm]
		, [CreateAgentId]
		, [CreateDtm]
		, [ChangeAgentId]
		, [ChangeDtm]
	FROM [stage].[ItemDetailV2] WITH (NOLOCK)
	WHERE (@ItemId IS NULL OR [ItemId] = @ItemId)
		AND (@RecordType IS NULL OR (@RecordType = 'PRODUCT' AND [ItemClassNm] = 'PRODUCT')
								 OR (@RecordType = 'PCODE' AND [ItemClassNm] = 'BD' AND [CommodityCd] = '0301')
								 OR (@RecordType = 'SCODE' AND [ItemClassNm] = 'BD' AND [CommodityCd] = '95990375')
								 OR (@RecordType = 'TA' AND [ItemDsc] LIKE 'TA,%')
								 OR (@RecordType = 'SA' AND [ItemDsc] LIKE 'SA,%')
								 OR (@RecordType = 'PBA' AND [ItemDsc] LIKE 'PBA,%')
								 OR (@RecordType = 'AA' AND [ItemDsc] LIKE 'AA,%')
								 OR (@RecordType = 'FW' AND [ItemDsc] LIKE 'FIRMWARE,%')
			)
	ORDER BY [ItemId];

END