CREATE TABLE [qan].[OsatBuildCriteriaTemplates] (
      [Id]              INT         IDENTITY (1, 1) NOT NULL
    , [SetTemplateId]   INT                         NOT NULL
    , [Ordinal]         INT                         NOT NULL
    , [Name]            VARCHAR(50)                 NOT NULL
      CONSTRAINT [PK_OsatBuildCriteriaTemplates] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_OsatBuildCriteriaTemplates_SetTemplateId_Ordinal] UNIQUE NONCLUSTERED ([SetTemplateId] ASC, [Ordinal] ASC)
    , CONSTRAINT [U_OsatBuildCriteriaTemplates_SetTemplateId_Name] UNIQUE NONCLUSTERED ([SetTemplateId] ASC, [Name] ASC)
);

GO

CREATE INDEX [IX_OsatBuildCriteriaTemplates_SetTemplateId] ON [qan].[OsatBuildCriteriaTemplates] ([SetTemplateId])
