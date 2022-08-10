-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-28 10:12:51.117
-- Description  : Type used for comparing auto checker build criteria condition records together.
--                The comparison is based on the combination of BuildCombinationId, AttributeTypeId
--                and ComparisonOperationId, so they are the primary key.
-- ================================================================================================
CREATE TYPE [qan].[IAcBuildCriteriaConditionsCompare] AS TABLE
(
	  [BuildCombinationId]     INT NOT NULL
	, [AttributeTypeId]        INT NOT NULL
	, [ComparisonOperationId]  INT NOT NULL
	, [Id]                     BIGINT
	, [Value]                  VARCHAR(4000) COLLATE SQL_Latin1_General_CP1_CS_AS
	, PRIMARY KEY ([BuildCombinationId], [AttributeTypeId], [ComparisonOperationId])
);
