CREATE VIEW [stage].[VSpeedProductFamilies]
	AS SELECT DISTINCT [CharacteristicValueTxt] AS [Name] FROM [stage].[ItemCharacteristicV2] WITH (NOLOCK) WHERE [CharacteristicNm] = 'MARKET_CODE_NAME' AND [CharacteristicValueTxt] IS NOT NULL;
