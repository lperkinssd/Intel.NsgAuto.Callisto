CREATE TABLE [qan].[OsatQualFilterImportBuildCriterias] (
      [Id]                     BIGINT  IDENTITY (1, 1) NOT NULL
    , [ImportId]               INT                     NOT NULL
    , [BuildCriteriaSetId]     BIGINT                  NOT NULL
    , [BuildCriteriaId]        BIGINT                  NOT NULL
    , [GroupIndex]             INT                         NULL
    , [GroupSourceIndex]       INT                         NULL
    , [CriteriaIndex]          INT                         NULL
    , [CriteriaSourceIndex]    INT                         NULL
    , CONSTRAINT [PK_OsatQualFilterImportBuildCriterias] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_OsatQualFilterImportBuildCriterias_BuildCriteriaId] UNIQUE NONCLUSTERED ([BuildCriteriaId] ASC)
);

GO

CREATE INDEX [IX_OsatQualFilterImportBuildCriterias_ImportId] ON [qan].[OsatQualFilterImportBuildCriterias] ([ImportId])

GO

CREATE INDEX [IX_OsatQualFilterImportBuildCriterias_BuildCriteriaSetId] ON [qan].[OsatQualFilterImportBuildCriterias] ([BuildCriteriaSetId])

GO

CREATE INDEX [IX_OsatQualFilterImportBuildCriterias_GroupIndex] ON [qan].[OsatQualFilterImportBuildCriterias] ([GroupIndex])

GO

CREATE INDEX [IX_OsatQualFilterImportBuildCriterias_GroupSourceIndex] ON [qan].[OsatQualFilterImportBuildCriterias] ([GroupSourceIndex])

GO

CREATE INDEX [IX_OsatQualFilterImportBuildCriterias_CriteriaIndex] ON [qan].[OsatQualFilterImportBuildCriterias] ([CriteriaIndex])

GO

CREATE INDEX [IX_OsatQualFilterImportBuildCriterias_CriteriaSourceIndex] ON [qan].[OsatQualFilterImportBuildCriterias] ([CriteriaSourceIndex])
