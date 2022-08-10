CREATE TABLE [ref].[OsatAttributeDataTypes] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (50)  NOT NULL,
    [NameDisplay]  VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_OsatAttributeDataTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatAttributeDataTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC),
    CONSTRAINT [U_OsatAttributeDataTypes_NameDisplay] UNIQUE NONCLUSTERED ([NameDisplay] ASC)
);
