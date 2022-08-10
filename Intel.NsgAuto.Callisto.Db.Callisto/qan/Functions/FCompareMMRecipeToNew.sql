-- ======================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-22 12:40:59.157
-- Description  : Compares system MM recipes to ones generated from Speed data.
-- Example      : SELECT * FROM [qan].[FCompareMMRecipeToNew]('980315');
-- ======================================================================================================
CREATE FUNCTION [qan].[FCompareMMRecipeToNew]
(
	  @PCode VARCHAR(10)
)
RETURNS @Result TABLE
(
	  [EntityType]       VARCHAR(50)
	, [PCode]            VARCHAR(10)
	, [ItemId]           VARCHAR(21)
	, [AttributeTypeId]  INT
	, [MissingFrom]      TINYINT
	, [Id1]              BIGINT
	, [Id2]              BIGINT
	, [Field]            VARCHAR(100)
	, [Different]        BIT
	, [Value1]           VARCHAR(MAX)
	, [Value2]           VARCHAR(MAX)
)
AS
BEGIN

	DECLARE @PCodes [qan].[IPCodes];
	INSERT INTO @PCodes VALUES (@PCode);

	INSERT INTO @Result
	(
		  [EntityType]
		, [PCode]
		, [ItemId]
		, [AttributeTypeId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	)
	SELECT
		  [EntityType]
		, [PCode]
		, [ItemId]
		, [AttributeTypeId]
		, [MissingFrom]
		, [Id1]
		, [Id2]
		, [Field]
		, [Different]
		, [Value1]
		, [Value2]
	FROM [qan].[FCompareMMRecipesToNew](@PCodes);

	RETURN;

END
