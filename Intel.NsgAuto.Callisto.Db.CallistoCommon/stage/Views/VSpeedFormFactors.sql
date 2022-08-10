CREATE VIEW [stage].[VSpeedFormFactors]
	AS SELECT DISTINCT [CharacteristicValueTxt] AS [Name] FROM [stage].[ItemCharacteristicV2] WITH (NOLOCK) WHERE [CharacteristicNm] = 'MM-FORM-FACT' AND [CharacteristicValueTxt] IS NOT NULL;
