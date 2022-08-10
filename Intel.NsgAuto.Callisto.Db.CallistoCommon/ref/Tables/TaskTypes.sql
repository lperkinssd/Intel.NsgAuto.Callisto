CREATE TABLE [ref].[TaskTypes] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [Name]               VARCHAR (100) NOT NULL,
    [ThresholdTimeLimit] INT           NULL,
    [CodeLocation]       VARCHAR (100) NULL,
    CONSTRAINT [PK_TaskTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_TaskTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
