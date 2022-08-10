CREATE VIEW [stage].[VSpeedMMRecipeItemsGbCategory]
AS SELECT
	  [RootItemId]
	, [ItemCategory]
	, [MaxItemId]          = MAX([ItemId])
	, [MaxRevision]        = MAX([Revision])
	, [MaxAssociationType] = MAX([AssociationType])
	, [Count]              = COUNT(*)
FROM [stage].[VSpeedMMRecipeItems] AS V1 WITH (NOLOCK)
GROUP BY [RootItemId], [ItemCategory]
