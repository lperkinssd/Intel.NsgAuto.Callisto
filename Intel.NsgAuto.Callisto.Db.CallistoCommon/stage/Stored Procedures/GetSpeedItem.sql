-- =====================================================================
-- Author       : bricschx
-- Create date  : 2020-10-01 18:02:37.597
-- Description  : Gets a speed item and all of its associated data
-- Example      : EXEC [stage].[GetSpeedItem] 'bricschx', '99A2ML'
-- =====================================================================
CREATE PROCEDURE [stage].[GetSpeedItem]
(
	  @UserId VARCHAR(25)
	, @ItemId NVARCHAR(21)
)
AS
BEGIN
	SET NOCOUNT ON;

	-- ItemDetailV2 record
	EXEC [stage].[GetItemDetailV2Records] @UserId, @ItemId;

	-- ItemCharacteristicDetailV2 records
	EXEC [stage].[GetItemCharacteristicDetailV2Records] @UserId, @ItemId;

	-- Parent items
	SELECT DISTINCT [RootItemId], [ParentItemId] AS [ItemId] FROM [stage].[VSpeedBomParentChildRelationships] WHERE [ChildItemId] = @ItemId AND [ParentItemId] IS NOT NULL
	UNION SELECT DISTINCT CAST(NULL AS NVARCHAR(21)) AS [RootItemId], [ParentItemId] AS [ItemId] FROM [stage].[BillOfMaterialDetailV2] WITH (NOLOCK) WHERE [ChildItemId] = @ItemId AND [ParentItemId] IS NOT NULL
	ORDER BY [RootItemId], [ItemId];

	-- Child items
	SELECT DISTINCT [RootItemId], [ChildItemId] AS [ItemId] FROM [stage].[VSpeedBomParentChildRelationships] WHERE [ParentItemId] = @ItemId AND [ChildItemId] IS NOT NULL
	UNION SELECT DISTINCT CAST(NULL AS NVARCHAR(21)) AS [RootItemId], [ChildItemId] AS [ItemId] FROM [stage].[BillOfMaterialDetailV2] WITH (NOLOCK) WHERE [ParentItemId] = @ItemId AND [ChildItemId] IS NOT NULL
	ORDER BY [RootItemId], [ItemId];

END
