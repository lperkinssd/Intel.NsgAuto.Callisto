CREATE TABLE [qan].[OsatBuildCriteriaSetReviewDecisions] (
    [Id]                 BIGINT         IDENTITY (1, 1) NOT NULL,
    [SnapshotReviewerId] BIGINT         NOT NULL,
    [VersionId]          BIGINT         NOT NULL,
    [ReviewStageId]      INT            NOT NULL,
    [ReviewGroupId]      INT            NOT NULL,
    [ReviewerId]         INT            NOT NULL,
    [IsApproved]         BIT            NOT NULL,
    [Comment]            VARCHAR (1000) NULL,
    [ReviewedOn]         DATETIME2 (7)  CONSTRAINT [DF_OsatBuildCriteriaSetReviewDecisions_ReviewedOn] DEFAULT (getutcdate()) NOT NULL
    CONSTRAINT [PK_OsatBuildCriteriaSetReviewDecisions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewDecisions_VersionId] ON [qan].[OsatBuildCriteriaSetReviewDecisions] ([VersionId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewDecisions_SnapshotReviewerId] ON [qan].[OsatBuildCriteriaSetReviewDecisions] ([SnapshotReviewerId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewDecisions_ReviewStageId] ON [qan].[OsatBuildCriteriaSetReviewDecisions] ([ReviewStageId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewDecisions_ReviewGroupId] ON [qan].[OsatBuildCriteriaSetReviewDecisions] ([ReviewGroupId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewDecisions_ReviewerId] ON [qan].[OsatBuildCriteriaSetReviewDecisions] ([ReviewerId])
