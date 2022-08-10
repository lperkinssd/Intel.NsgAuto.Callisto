CREATE TABLE [qan].[OsatPasVersionImportMessages] (
    [Id]              BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]       INT           NOT NULL,
    [RecordId]        BIGINT        NULL,
    [RecordNumber]    INT           NULL,
    [MessageType]     VARCHAR (20)  NOT NULL, 
    [FieldName]       VARCHAR (100) NULL,
    [Message]         VARCHAR (256) NOT NULL,
    CONSTRAINT [PK_OsatPasVersionImportMessages] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_OsatPasVersionImportMessages_VersionId] ON [qan].[OsatPasVersionImportMessages] ([VersionId])

GO

CREATE INDEX [IX_OsatPasVersionImportMessages_RecordId] ON [qan].[OsatPasVersionImportMessages] ([RecordId])

GO

CREATE INDEX [IX_OsatPasVersionImportMessages_RecordNumber] ON [qan].[OsatPasVersionImportMessages] ([RecordNumber])

GO

CREATE INDEX [IX_OsatPasVersionImportMessages_MessageType] ON [qan].[OsatPasVersionImportMessages] ([MessageType])

GO

CREATE INDEX [IX_OsatPasVersionImportMessages_FieldName] ON [qan].[OsatPasVersionImportMessages] ([FieldName])
