CREATE TABLE [qan].[OsatBuildCriteriaSetReviewChangeHistory] (
    [Id]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]   BIGINT        NOT NULL,
    [Description] VARCHAR (MAX) NOT NULL,
    [ChangedBy]   VARCHAR (25)  NOT NULL,
    [ChangedOn]   DATETIME2 (7) CONSTRAINT [DF_OsatBuildCriteriaSetReviewChangeHistory_ChangedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_OsatBuildCriteriaSetReviewChangeHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewChangeHistory_VersionId] ON [qan].[OsatBuildCriteriaSetReviewChangeHistory] ([VersionId])
