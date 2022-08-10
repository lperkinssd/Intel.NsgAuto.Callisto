CREATE TABLE [ref].[EmailTemplates] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (50)  NOT NULL,
    [Subject]      VARCHAR (200) NOT NULL,
    [IsHtml]       BIT           NOT NULL,
    [Body]         VARCHAR (MAX) NULL,
    [BodyXslId]    INT           NULL,
    [BodyXml]      VARCHAR (MAX) NULL,
    CONSTRAINT [PK_EmailTemplates_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_EmailTemplates_Name] UNIQUE NONCLUSTERED ([Name] ASC),
    CONSTRAINT [CTK_EmailTemplates_Body_BodyXslId_BodyXml] CHECK (([Body] IS NOT NULL AND [BodyXslId] IS NULL AND [BodyXml] IS NULL) OR ([Body] IS NULL AND [BodyXslId] IS NOT NULL AND [BodyXml] IS NOT NULL))
);
