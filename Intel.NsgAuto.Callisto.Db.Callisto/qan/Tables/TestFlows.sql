CREATE TABLE [qan].[TestFlows] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (50)  NOT NULL,
    [CreatedBy]    VARCHAR (25)  NOT NULL,
    [CreatedOn]    DATETIME2 (7) CONSTRAINT [DF_TestFlows_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]    VARCHAR (25)  NOT NULL,
    [UpdatedOn]    DATETIME2 (7) CONSTRAINT [DF_TestFlows_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_TestFlows] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_TestFlows_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
