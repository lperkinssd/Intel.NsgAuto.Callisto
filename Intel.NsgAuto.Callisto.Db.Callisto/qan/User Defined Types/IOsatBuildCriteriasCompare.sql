-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-31 15:48:15.870
-- Description  : Type used for comparing osat build criteria  records together. The comparison is based
--                on the combination: BuildCombinationId and Ordinal, so they are the primary key.
-- =====================================================================================================
CREATE TYPE [qan].[IOsatBuildCriteriasCompare] AS TABLE
(
	  [BuildCombinationId]     INT NOT NULL
	, [Ordinal]                INT NOT NULL
	, [Id]                     BIGINT
	, [Name]                   VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CS_AS
	, PRIMARY KEY ([BuildCombinationId], [Ordinal])
);
