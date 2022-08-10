CREATE TABLE [qan].[OsatQualFilterExports]
(
      [Id]                INT            IDENTITY (1, 1)                                                            NOT NULL
    , [CreatedBy]         VARCHAR (25)                                                                              NOT NULL
    , [CreatedOn]         DATETIME2 (7)  CONSTRAINT [DF_OsatQualFilterExports_CreatedOn] DEFAULT (getutcdate())     NOT NULL
    , [UpdatedBy]         VARCHAR (25)                                                                              NOT NULL
    , [UpdatedOn]         DATETIME2 (7)  CONSTRAINT [DF_OsatQualFilterExports_UpdatedOn] DEFAULT (getutcdate())     NOT NULL
    , [GeneratedOn]       DATETIME2 (7)                                                                                 NULL
    , [DeliveredOn]       DATETIME2 (7)                                                                                 NULL
    , [FileName]          VARCHAR(250)                                                                                  NULL
    , [FileLengthInBytes] INT                                                                                           NULL
    , CONSTRAINT [PK_OsatQualFilterExports] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_OsatQualFilterExports_GeneratedOn] ON [qan].[OsatQualFilterExports] ([GeneratedOn])

GO

CREATE INDEX [IX_OsatQualFilterExports_DeliveredOn] ON [qan].[OsatQualFilterExports] ([DeliveredOn])
