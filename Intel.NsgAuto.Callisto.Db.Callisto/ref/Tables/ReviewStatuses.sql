CREATE TABLE [ref].[ReviewStatuses] (
    [Id]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ReviewStatuses] PRIMARY KEY CLUSTERED ([Id] ASC)
);

