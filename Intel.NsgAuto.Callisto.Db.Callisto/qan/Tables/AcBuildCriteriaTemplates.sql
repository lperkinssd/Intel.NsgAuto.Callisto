CREATE TABLE [qan].[AcBuildCriteriaTemplates] (
      [Id]              INT         IDENTITY (1, 1) NOT NULL
    , [Name]            VARCHAR(50)                 NOT NULL
    , [DesignFamilyId]  INT                         NOT NULL
      CONSTRAINT [PK_AcBuildCriteriaTemplates] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_AcBuildCriteriaTemplates_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);

GO

CREATE INDEX [IX_AcBuildCriteriaTemplates_DesignFamilyId] ON [qan].[AcBuildCriteriaTemplates] ([DesignFamilyId])
