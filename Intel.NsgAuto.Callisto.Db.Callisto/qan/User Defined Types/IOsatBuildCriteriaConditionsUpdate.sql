CREATE TYPE [qan].[IOsatBuildCriteriaConditionsUpdate] AS TABLE
(
    [Id]                   INT           NOT NULL,
    [AttributeTypeName]       VARCHAR (50)  NOT NULL,
    [ComparisonOperationKey]  VARCHAR (25)  NOT NULL,
    [Value]                   VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
