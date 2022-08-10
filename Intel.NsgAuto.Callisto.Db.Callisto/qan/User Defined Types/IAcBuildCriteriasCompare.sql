-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-30 12:08:10.297
-- Description  : Type used for comparing auto checker build criteria records together. The
--                comparison is based on BuildCombinationId so it is the primary key (not Id which
--                may be null in many cases).
-- ================================================================================================
CREATE TYPE [qan].[IAcBuildCriteriasCompare] AS TABLE
(
	  [Id]                     BIGINT
	, [BuildCombinationId]     INT NOT NULL PRIMARY KEY
	, [DesignId]               INT NOT NULL
	, [FabricationFacilityId]  INT NOT NULL
	, [TestFlowId]             INT
	, [ProbeConversionId]      INT
	, [EffectiveOn]            DATETIME2(7)
);
