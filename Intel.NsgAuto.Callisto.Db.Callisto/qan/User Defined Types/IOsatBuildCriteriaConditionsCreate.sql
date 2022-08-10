CREATE TYPE [qan].[IOsatBuildCriteriaConditionsCreate] AS TABLE
(
    [Index]                   INT           NOT NULL,
    [BuildCriteriaIndex]      INT           NOT NULL,
    [AttributeTypeName]       VARCHAR (50)  NOT NULL,
    [ComparisonOperationKey]  VARCHAR (25)  NOT NULL,
    [Value]                   VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Index] ASC)
);
