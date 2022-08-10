-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16
-- Description  : Type used for comparing osat build criteria set records together. The comparison
--                is based on BuildCombinationId so it is the primary key (not Id which may be null
--                in many cases).
-- ================================================================================================
CREATE TYPE [qan].[IOsatBuildCriteriaSetsCompare] AS TABLE
(
	  [Id]                     BIGINT
	, [BuildCombinationId]     INT NOT NULL PRIMARY KEY
	, [EffectiveOn]            DATETIME2(7)
);
