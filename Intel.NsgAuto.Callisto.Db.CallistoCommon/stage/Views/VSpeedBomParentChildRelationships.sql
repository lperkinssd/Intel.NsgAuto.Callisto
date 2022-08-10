CREATE VIEW [stage].[VSpeedBomParentChildRelationships]
	AS SELECT DISTINCT [RootItemId], [ParentItemId], [ChildItemId] FROM [stage].[BillOfMaterialExplosionDetailV2] WITH (NOLOCK)
