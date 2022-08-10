-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-15 15:30:11.677
-- Description  : Type used for comparing MM Recipe records together. The comparison is based on
--                PCode so it is the primary key (not Id which may be null in many cases).
-- ================================================================================================
CREATE TYPE [qan].[IMMRecipesCompare] AS TABLE
(
	  [Id]                      BIGINT
	, [PCode]                   VARCHAR(10) NOT NULL PRIMARY KEY
	, [ProductName]             VARCHAR(200)
	, [ProductFamilyId]         INT
	, [MOQ]                     INT
	, [ProductionProductCode]   VARCHAR(25)
	, [SCode]                   VARCHAR(10)
	, [FormFactorId]            INT
	, [CustomerId]              INT
	, [PRQDate]                 DATETIME2(7)
	, [CustomerQualStatusId]    INT
	, [SCodeProductCode]        VARCHAR(20)
	, [ModelString]             VARCHAR(20)
	, [PLCStageId]              INT
	, [ProductLabelId]          BIGINT
);
