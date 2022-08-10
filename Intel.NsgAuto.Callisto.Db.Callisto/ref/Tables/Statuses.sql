CREATE TABLE [ref].[Statuses] (
    [Id]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (25) NOT NULL,
    CONSTRAINT [PK_Statuses] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_Statuses_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
