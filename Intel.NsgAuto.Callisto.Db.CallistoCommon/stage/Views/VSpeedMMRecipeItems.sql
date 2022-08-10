-- ==========================================================================
-- Author       : bricschx
-- Create date  : 2020-11-03 10:03:59.870
-- Description  : This view contains the important logic for mapping speed
--                item data to mm recipe items. This view is refreshed to the
--                table SpeedMMRecipeItems for performance reasons as part of
--                the Speed pull post processing steps.
-- ==========================================================================
CREATE VIEW [stage].[VSpeedMMRecipeItems]
AS SELECT DISTINCT
	  B.[@ItemId] AS [RootItemId]
	, CASE
	  WHEN P.[ItemId] IS NOT NULL THEN 'PCODE' -- B.[ItemClassDsc] = 'BD' AND B.[CommodityCd] = '0301'
	  WHEN S.[ItemId] IS NOT NULL THEN 'SCODE' -- B.[ItemClassDsc] = 'BD' AND B.[CommodityCd] = '95990375'
	  WHEN I.[ItemId] IS NOT NULL AND I.[IntelFlash] = 'Y' AND I.[MemoryAssyType] = 'ASSY' AND I.[MemoryType] = 'FLASH' THEN 'NAND_MEDIA'
	  WHEN B.[ItemDsc] LIKE 'TA,%' THEN 'TA'
	  WHEN B.[ItemDsc] LIKE 'SA,%' THEN 'SA'
	  WHEN B.[ItemDsc] LIKE 'PBA,%' THEN 'PBA'
	  WHEN B.[ItemDsc] LIKE 'AA,%' THEN 'AA'
	  WHEN B.[ItemDsc] LIKE 'FIRMWARE,%' THEN 'FIRMWARE'
	  END AS [ItemCategory]
	, B.[ChildItemId] AS [ItemId]
	, B.[ChildItemRevisionNbr] AS [Revision]
	, B.[BillOfMaterialAssociationTypeNm] AS [AssociationType]
FROM [stage].[BillOfMaterialExplosionDetailV2] AS B WITH (NOLOCK)
LEFT OUTER JOIN [stage].[SpeedPCodeItems] AS P WITH (NOLOCK) ON (P.[ItemId] = B.[ChildItemId])
LEFT OUTER JOIN [stage].[SpeedSCodeItems] AS S WITH (NOLOCK) ON (S.[ItemId] = B.[ChildItemId])
LEFT OUTER JOIN [stage].[SpeedIcFlashItems] AS I WITH (NOLOCK) ON (I.[ItemId] = B.[ChildItemId])
WHERE
	   P.[ItemId] IS NOT NULL
	OR S.[ItemId] IS NOT NULL
	OR (I.[ItemId] IS NOT NULL AND I.[IntelFlash] = 'Y' AND I.[MemoryAssyType] = 'ASSY' AND I.[MemoryType] = 'FLASH')
	OR B.[ItemDsc] LIKE 'TA,%'
	OR B.[ItemDsc] LIKE 'SA,%'
	OR B.[ItemDsc] LIKE 'PBA,%'
	OR B.[ItemDsc] LIKE 'AA,%'
	OR B.[ItemDsc] LIKE 'FIRMWARE,%'
