CREATE VIEW [stage].[VSpeedIcFlashCharacteristicSummary]
	AS SELECT
		  [CharacteristicNm]
		 , [CharacteristicDsc]
		 , COUNT(*) AS [Count]
		 , MAX([CharacteristicValueTxt]) AS [SampleValue]
	FROM [stage].[ItemCharacteristicV2] WITH (NOLOCK)
	WHERE [ItemId] IN
	(
		SELECT [ItemId] FROM [stage].[ItemDetailV2] WITH (NOLOCK) WHERE [ItemDsc] LIKE 'IC,FLASH,%'
	)
	GROUP BY [CharacteristicNm], [CharacteristicDsc]
