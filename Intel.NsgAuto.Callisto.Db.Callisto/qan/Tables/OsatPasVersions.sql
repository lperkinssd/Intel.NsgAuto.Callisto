CREATE TABLE [qan].[OsatPasVersions] (
    [Id]                INT                 IDENTITY (1, 1) NOT NULL,
    [Version]           INT                 NOT NULL,
    [IsActive]          BIT                 CONSTRAINT [DF_OsatPasVersions_IsActive] DEFAULT ((1)) NOT NULL,
    [IsPOR]             BIT                 CONSTRAINT [DF_OsatPasVersions_IsPOR] DEFAULT ((0)) NOT NULL,
    [StatusId]          INT                 NOT NULL,
    [CreatedBy]         VARCHAR (25)        NOT NULL,
    [CreatedOn]         DATETIME2 (7)       CONSTRAINT [DF_OsatPasVersions_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]         VARCHAR (25)        NOT NULL,
    [UpdatedOn]         DATETIME2 (7)       CONSTRAINT [DF_OsatPasVersions_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    [CombinationId]     INT                 NOT NULL,
    [OriginalFileName]  VARCHAR(250)        NOT NULL,
    [FileLengthInBytes] INT                 NOT NULL,
    CONSTRAINT [PK_OsatPasVersions] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatPasVersionRecords_Version_CombinationId] UNIQUE NONCLUSTERED ([Version] ASC, [CombinationId] ASC)
);

GO

CREATE INDEX [IX_OsatPasVersions_IsPOR] ON [qan].[OsatPasVersions] ([IsPOR])

GO

CREATE INDEX [IX_OsatPasVersions_StatusId] ON [qan].[OsatPasVersions] ([StatusId])

GO

CREATE INDEX [IX_OsatPasVersions_CombinationId] ON [qan].[OsatPasVersions] ([CombinationId])
