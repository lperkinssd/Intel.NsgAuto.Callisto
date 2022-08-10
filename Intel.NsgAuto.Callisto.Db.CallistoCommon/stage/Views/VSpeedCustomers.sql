CREATE VIEW [stage].[VSpeedCustomers]
	AS SELECT DISTINCT [CharacteristicValueTxt] AS [Name] FROM [stage].[ItemCharacteristicV2] WITH (NOLOCK) WHERE [CharacteristicNm] = 'MM-CUST-CUSTOMER' AND [CharacteristicValueTxt] IS NOT NULL;
