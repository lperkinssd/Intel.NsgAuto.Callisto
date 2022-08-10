-- ==============================================================================
-- Author       : bricschx
-- Create date  : 2020-10-06 16:04:51.567
-- Description  : Generates the core part of a new MM recipe for the given PCode
-- Example      : SELECT * FROM [qan].[FMMRecipeNewCore]('99A2ML');
-- ==============================================================================
CREATE FUNCTION [qan].[FMMRecipeNewCore]
(
	  @PCode VARCHAR(10)
)
RETURNS @Result TABLE
(
	  [IsPOR]                   BIT
	, [IsActive]                BIT
	, [StatusId]                INT
	, [StatusName]              VARCHAR(25)
	, [PCode]                   VARCHAR(10)
	, [ProductName]             VARCHAR(200)
	, [ProductFamilyId]         INT
	, [ProductFamilyName]       VARCHAR(50)
	, [MOQ]                     INT
	, [ProductionProductCode]   VARCHAR(25)
	, [SCode]                   VARCHAR(10)
	, [FormFactorId]            INT
	, [FormFactorName]          VARCHAR(25)
	, [CustomerId]              INT
	, [CustomerName]            VARCHAR(25)
	, [PRQDate]                 DATETIME2(7)
	, [CustomerQualStatusId]    INT
	, [CustomerQualStatusName]  VARCHAR(25)
	, [SCodeProductCode]        VARCHAR(20)
	, [ModelString]             VARCHAR(20)
	, [PLCStageId]              INT
	, [PLCStageName]            VARCHAR(25)
	, [ProductLabelId]          BIGINT
)
AS
BEGIN

	DECLARE @PCodes [qan].[IPCodes];
	INSERT INTO @PCodes VALUES (@PCode);

	INSERT INTO @Result
	SELECT TOP 1
		  [IsPOR]
		, [IsActive]
		, [StatusId]
		, [StatusName]
		, [PCode]
		, [ProductName]
		, [ProductFamilyId]
		, [ProductFamilyName]
		, [MOQ]
		, [ProductionProductCode]
		, [SCode]
		, [FormFactorId]
		, [FormFactorName]
		, [CustomerId]
		, [CustomerName]
		, [PRQDate]
		, [CustomerQualStatusId]
		, [CustomerQualStatusName]
		, [SCodeProductCode]
		, [ModelString]
		, [PLCStageId]
		, [PLCStageName]
		, [ProductLabelId]
	FROM [qan].[FMMRecipesNewCore](@PCodes);

	RETURN;

END
