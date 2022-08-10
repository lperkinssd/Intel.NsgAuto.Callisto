CREATE TABLE [qan].[MMRecipeReviewChangeHistory] (
    [Id]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]   BIGINT        NOT NULL,
    [Description] VARCHAR (MAX) NOT NULL,
    [ChangedBy]   VARCHAR (25)  NOT NULL,
    [ChangedOn]   DATETIME2 (7) CONSTRAINT [DF_MMRecipeReviewChangeHistory_ChangedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_MMRecipeReviewChangeHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_MMRecipeReviewChangeHistory_VersionId] ON [qan].[MMRecipeReviewChangeHistory] ([VersionId])
