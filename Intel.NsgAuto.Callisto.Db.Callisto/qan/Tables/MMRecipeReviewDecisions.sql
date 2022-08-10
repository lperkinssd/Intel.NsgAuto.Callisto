CREATE TABLE [qan].[MMRecipeReviewDecisions] (
    [Id]                 BIGINT         IDENTITY (1, 1) NOT NULL,
    [SnapshotReviewerId] BIGINT         NOT NULL,
    [VersionId]          BIGINT         NOT NULL,
    [ReviewStageId]      INT            NOT NULL,
    [ReviewGroupId]      INT            NOT NULL,
    [ReviewerId]         INT            NOT NULL,
    [IsApproved]         BIT            NOT NULL,
    [Comment]            VARCHAR (1000) NULL,
    [ReviewedOn]         DATETIME2 (7)  CONSTRAINT [DF_MMRecipeReviewDecisions_ReviewedOn] DEFAULT (getutcdate()) NOT NULL
    CONSTRAINT [PK_MMRecipeReviewDecisions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_MMRecipeReviewDecisions_VersionId] ON [qan].[MMRecipeReviewDecisions] ([VersionId])

GO

CREATE INDEX [IX_MMRecipeReviewDecisions_SnapshotReviewerId] ON [qan].[MMRecipeReviewDecisions] ([SnapshotReviewerId])

GO

CREATE INDEX [IX_MMRecipeReviewDecisions_ReviewStageId] ON [qan].[MMRecipeReviewDecisions] ([ReviewStageId])

GO

CREATE INDEX [IX_MMRecipeReviewDecisions_ReviewGroupId] ON [qan].[MMRecipeReviewDecisions] ([ReviewGroupId])

GO

CREATE INDEX [IX_MMRecipeReviewDecisions_ReviewerId] ON [qan].[MMRecipeReviewDecisions] ([ReviewerId])
