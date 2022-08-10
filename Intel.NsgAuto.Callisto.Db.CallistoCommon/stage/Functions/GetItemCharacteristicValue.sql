-- ============================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-21 10:01:36.273
-- Description  : Gets the value of the item characteristic with the given name
-- Example      : SELECT [stage].[GetItemCharacteristicValue]('99A2ML', 'MM-ITEM-MARKET-NAME');
-- ============================================================================================
CREATE   FUNCTION [stage].[GetItemCharacteristicValue]
(
	  @ItemId NVARCHAR(21)
	, @CharacteristicNm NVARCHAR(30)
)
RETURNS NVARCHAR(255)
AS
BEGIN
	DECLARE @Result NVARCHAR(255);

	SELECT TOP 1 @Result = MAX([CharacteristicValueTxt]) FROM [stage].[ItemCharacteristicV2] WITH (NOLOCK) WHERE [ItemId] = @ItemId AND [CharacteristicNm] = @CharacteristicNm;

	RETURN (@Result);
END