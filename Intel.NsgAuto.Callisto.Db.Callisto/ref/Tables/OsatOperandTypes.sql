CREATE TABLE [ref].[OsatOperandTypes] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_OsatOperandTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatOperandTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
