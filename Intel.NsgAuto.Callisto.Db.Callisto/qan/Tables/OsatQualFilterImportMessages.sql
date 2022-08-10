CREATE TABLE [qan].[OsatQualFilterImportMessages] (
      [Id]                     BIGINT        IDENTITY (1, 1) NOT NULL
    , [ImportId]               INT                           NOT NULL
    , [MessageType]            VARCHAR (20)                  NOT NULL
    , [Message]                VARCHAR (500)                 NOT NULL
    , [GroupIndex]             INT                               NULL
    , [GroupSourceIndex]       INT                               NULL
    , [CriteriaIndex]          INT                               NULL
    , [CriteriaSourceIndex]    INT                               NULL
    , [GroupFieldIndex]        INT                               NULL
    , [GroupFieldSourceIndex]  INT                               NULL
    , [GroupFieldName]         VARCHAR (100)                     NULL
    , CONSTRAINT [PK_OsatQualFilterImportMessages] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_OsatQualFilterImportMessages_ImportId] ON [qan].[OsatQualFilterImportMessages] ([ImportId])

GO

CREATE INDEX [IX_OsatQualFilterImportMessages_MessageType] ON [qan].[OsatQualFilterImportMessages] ([MessageType])

GO

CREATE INDEX [IX_OsatQualFilterImportMessages_GroupIndex] ON [qan].[OsatQualFilterImportMessages] ([GroupIndex])

GO

CREATE INDEX [IX_OsatQualFilterImportMessages_GroupSourceIndex] ON [qan].[OsatQualFilterImportMessages] ([GroupSourceIndex])

GO

CREATE INDEX [IX_OsatQualFilterImportMessages_CriteriaIndex] ON [qan].[OsatQualFilterImportMessages] ([CriteriaIndex])

GO

CREATE INDEX [IX_OsatQualFilterImportMessages_CriteriaSourceIndex] ON [qan].[OsatQualFilterImportMessages] ([CriteriaSourceIndex])

GO

CREATE INDEX [IX_OsatQualFilterImportMessages_GroupFieldIndex] ON [qan].[OsatQualFilterImportMessages] ([GroupFieldIndex])

GO

CREATE INDEX [IX_OsatQualFilterImportMessages_GroupFieldSourceIndex] ON [qan].[OsatQualFilterImportMessages] ([GroupFieldSourceIndex])

GO

CREATE INDEX [IX_OsatQualFilterImportMessages_GroupFieldName] ON [qan].[OsatQualFilterImportMessages] ([GroupFieldName])
