-- =======================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-23 19:50:46.940
-- Description  : Gets item characteristic v2 records
-- Example      : EXEC [stage].[GetItemCharacteristicDetailV2Records] 'bricschx', '99A2ML'
-- =======================================================================================
CREATE   PROCEDURE [stage].[GetItemCharacteristicDetailV2Records]
(
	  @UserId VARCHAR(25)
	, @ItemId NVARCHAR(21) = NULL
	, @CharacteristicId INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		  [PullDateTime]
		, [ItemId]
		, [CharacteristicId]
		, [CharacteristicNm]
		, [CharacteristicDsc]
		, [CharacteristicValueTxt]
		, [CharacteristicSequenceNbr]
		, [CharacteristicLastModifiedDt]
		, [CharacteristicLastModifiedUsr]
		, [CreateAgentId]
		, [CreateDtm]
		, [ChangeAgentId]
		, [ChangeDtm]
	FROM [stage].[ItemCharacteristicV2] WITH (NOLOCK)
	WHERE (@ItemId IS NULL OR [ItemId] = @ItemId) AND (@CharacteristicId IS NULL OR [CharacteristicId] = @CharacteristicId)
	ORDER BY [ItemId], [CharacteristicNm], [CharacteristicId];

END