CREATE TABLE [qan].[AcBuildCriteriaReviewDecisions] (
    [Id]                 BIGINT         IDENTITY (1, 1) NOT NULL,
    [SnapshotReviewerId] BIGINT         NOT NULL,
    [VersionId]          BIGINT         NOT NULL,
    [ReviewStageId]      INT            NOT NULL,
    [ReviewGroupId]      INT            NOT NULL,
    [ReviewerId]         INT            NOT NULL,
    [IsApproved]         BIT            NOT NULL,
    [Comment]            VARCHAR (1000) NULL,
    [ReviewedOn]         DATETIME2 (7)  CONSTRAINT [DF_AcBuildCriteriaReviewDecisions_ReviewedOn] DEFAULT (getutcdate()) NOT NULL
    CONSTRAINT [PK_AcBuildCriteriaReviewDecisions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_AcBuildCriteriaReviewDecisions_VersionId] ON [qan].[AcBuildCriteriaReviewDecisions] ([VersionId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewDecisions_SnapshotReviewerId] ON [qan].[AcBuildCriteriaReviewDecisions] ([SnapshotReviewerId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewDecisions_ReviewStageId] ON [qan].[AcBuildCriteriaReviewDecisions] ([ReviewStageId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewDecisions_ReviewGroupId] ON [qan].[AcBuildCriteriaReviewDecisions] ([ReviewGroupId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewDecisions_ReviewerId] ON [qan].[AcBuildCriteriaReviewDecisions] ([ReviewerId])
