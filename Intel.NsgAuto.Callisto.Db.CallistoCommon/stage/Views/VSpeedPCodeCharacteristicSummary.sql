CREATE VIEW [stage].[VSpeedPCodeCharacteristicSummary]
	AS SELECT
		  [CharacteristicNm]
		 , [CharacteristicDsc]
		 , COUNT(*) AS [Count]
		 , MAX([CharacteristicValueTxt]) AS [SampleValue]
	FROM [stage].[ItemCharacteristicV2] WITH (NOLOCK)
	WHERE [ItemId] IN
	(
		SELECT [ItemId] FROM [stage].[ItemDetailV2] WITH (NOLOCK) WHERE [ItemClassNm] = 'BD' AND [CommodityCd] = '0301'
	)
	GROUP BY [CharacteristicNm], [CharacteristicDsc]
