CREATE TABLE [ref].[EmailTemplateBodyXsls] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (50)  NOT NULL,
    [Value]        VARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_EmailTemplateBodyXsls] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_EmailTemplateBodyXsls_Name] UNIQUE NONCLUSTERED ([Name] ASC),
);
