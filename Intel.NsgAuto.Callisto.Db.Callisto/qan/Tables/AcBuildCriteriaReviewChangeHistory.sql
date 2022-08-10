CREATE TABLE [qan].[AcBuildCriteriaReviewChangeHistory] (
    [Id]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]   BIGINT        NOT NULL,
    [Description] VARCHAR (MAX) NOT NULL,
    [ChangedBy]   VARCHAR (25)  NOT NULL,
    [ChangedOn]   DATETIME2 (7) CONSTRAINT [DF_AcBuildCriteriaReviewChangeHistory_ChangedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_AcBuildCriteriaReviewChangeHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_AcBuildCriteriaReviewChangeHistory_VersionId] ON [qan].[AcBuildCriteriaReviewChangeHistory] ([VersionId])
