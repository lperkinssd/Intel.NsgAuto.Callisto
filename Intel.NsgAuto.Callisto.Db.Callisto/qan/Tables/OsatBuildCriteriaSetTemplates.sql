CREATE TABLE [qan].[OsatBuildCriteriaSetTemplates] (
      [Id]              INT         IDENTITY (1, 1) NOT NULL
    , [Name]            VARCHAR(50)                 NOT NULL
    , [DesignFamilyId]  INT                         NOT NULL
      CONSTRAINT [PK_OsatBuildCriteriaSetTemplates] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_OsatBuildCriteriaSetTemplates_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);

GO

CREATE INDEX [IX_OsatBuildCriteriaSetTemplates_DesignFamilyId] ON [qan].[OsatBuildCriteriaSetTemplates] ([DesignFamilyId])
