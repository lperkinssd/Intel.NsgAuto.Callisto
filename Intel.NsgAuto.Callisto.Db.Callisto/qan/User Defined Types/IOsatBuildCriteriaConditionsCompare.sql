-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16
-- Description  : Type used for comparing osat build criteria condition records together. The
--                comparison is based on the combination: BuildCombinationId, BuildCriteriaOrdinal,
--                AttributeTypeId and ComparisonOperationId, so they are the primary key.
-- ================================================================================================
CREATE TYPE [qan].[IOsatBuildCriteriaConditionsCompare] AS TABLE
(
	  [BuildCombinationId]     INT NOT NULL
	, [BuildCriteriaOrdinal]   INT NOT NULL
	, [AttributeTypeId]        INT NOT NULL
	, [ComparisonOperationId]  INT NOT NULL
	, [Id]                     BIGINT
	, [Value]                  VARCHAR(4000) COLLATE SQL_Latin1_General_CP1_CS_AS
	, PRIMARY KEY ([BuildCombinationId], [BuildCriteriaOrdinal], [AttributeTypeId], [ComparisonOperationId])
);
