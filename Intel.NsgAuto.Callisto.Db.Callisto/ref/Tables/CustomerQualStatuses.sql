CREATE TABLE [ref].[CustomerQualStatuses] (
    [Id]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (25) NOT NULL,
    CONSTRAINT [PK_CustomerQualStatuses] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_CustomerQualStatuses_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
