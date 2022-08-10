CREATE TABLE [qan].[OsatQualFilterExportFiles] (
      [Id]                INT                 IDENTITY (1, 1)                                                            NOT NULL
    , [ExportId]          INT                                                                                            NOT NULL
    , [OsatId]            INT                                                                                            NOT NULL
    , [DesignId]          INT                                                                                            NOT NULL
    , [CreatedBy]         VARCHAR (25)                                                                                   NOT NULL
    , [CreatedOn]         DATETIME2 (7)       CONSTRAINT [DF_OsatQualFilterExportFiles_CreatedOn] DEFAULT (getutcdate()) NOT NULL
    , [UpdatedBy]         VARCHAR (25)                                                                                   NOT NULL
    , [UpdatedOn]         DATETIME2 (7)       CONSTRAINT [DF_OsatQualFilterExportFiles_UpdatedOn] DEFAULT (getutcdate()) NOT NULL
    , [GeneratedOn]       DATETIME2 (7)                                                                                      NULL
    , [DeliveredOn]       DATETIME2 (7)                                                                                      NULL
    , [Name]              VARCHAR (250)                                                                                      NULL
    , [LengthInBytes]     INT                                                                                                NULL
    , CONSTRAINT [PK_OsatQualFilterExportFiles] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_OsatQualFilterExportFiles_ExportId] ON [qan].[OsatQualFilterExportFiles] ([ExportId])

GO

CREATE INDEX [IX_OsatQualFilterExportFiles_OsatId] ON [qan].[OsatQualFilterExportFiles] ([OsatId])

GO

CREATE INDEX [IX_OsatQualFilterExportFiles_DesignId] ON [qan].[OsatQualFilterExportFiles] ([DesignId])

GO

CREATE INDEX [IX_OsatQualFilterExportFiles_GeneratedOn] ON [qan].[OsatQualFilterExportFiles] ([GeneratedOn])

GO

CREATE INDEX [IX_OsatQualFilterExportFiles_DeliveredOn] ON [qan].[OsatQualFilterExportFiles] ([DeliveredOn])
