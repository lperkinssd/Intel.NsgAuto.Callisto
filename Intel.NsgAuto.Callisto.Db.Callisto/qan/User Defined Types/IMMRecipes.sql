-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-22 11:30:34.387
-- Description  : This type should more or less stay in sync with the MMRecipes table. Do not put
--                constraints (such as not null, primary key, etc.) in this type due to how it is 
--                used, but indexes are okay.
-- ================================================================================================
CREATE TYPE [qan].[IMMRecipes] AS TABLE
(
	  [Id]                      BIGINT
	, [PCode]                   VARCHAR(10)
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
	, INDEX [IX_Id] ([Id])
	, INDEX [IX_PCode] ([PCode])
);
