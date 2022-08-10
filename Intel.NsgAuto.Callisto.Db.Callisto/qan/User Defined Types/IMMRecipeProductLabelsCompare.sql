-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-15 16:14:31.513
-- Description  : Type used for comparing MM Recipes' product label records together. The
--                comparison is based on PCode so it is the primary key (not Id).
-- ================================================================================================
CREATE TYPE [qan].[IMMRecipeProductLabelsCompare] AS TABLE
(
	  [PCode]                     VARCHAR(10) NOT NULL PRIMARY KEY
	, [Id]                        BIGINT
	, [ProductionProductCode]     VARCHAR(25)
	, [ProductFamilyId]           INT
	, [CustomerId]                INT
	, [ProductFamilyNameSeriesId] INT
	, [Capacity]                  VARCHAR(50)
	, [ModelString]               VARCHAR(50)
	, [VoltageCurrent]            VARCHAR(50)
	, [InterfaceSpeed]            VARCHAR(50)
	, [OpalTypeId]                INT
	, [KCCId]                     VARCHAR(50)
	, [CanadianStringClass]       VARCHAR(50)
);
