CREATE TABLE [qan].[OsatBuildCriteriaSetReviewEmails] (
    [Id]                      BIGINT         IDENTITY (1, 1) NOT NULL,
    [VersionId]               BIGINT         NOT NULL,
    [BatchId]                 INT            NOT NULL,
    [SnapshotReviewStageId]   BIGINT         NULL,
    [ReviewStageId]           INT            NULL,
    [SnapshotReviewGroupId]   BIGINT         NULL,
    [ReviewGroupId]           INT            NULL,
    [EmailTemplateId]         INT            NOT NULL,
    [EmailTemplateName]       VARCHAR (50)   NOT NULL,
    [To]                      VARCHAR (2000) NOT NULL,
    [RecipientName]           VARCHAR (255)  NULL,
    [VersionDescription]      VARCHAR (500)  NULL,
    [ReviewAtDescription]     VARCHAR (255)  NULL,
    [SentOn]                  DATETIME2 (7)  NULL,
    [Cc]                      VARCHAR (2000) NULL,
    [Bcc]                     VARCHAR (2000) NULL,
    CONSTRAINT [PK_OsatBuildCriteriaSetReviewEmails] PRIMARY KEY CLUSTERED ([Id] ASC),
);

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewEmails_VersionId] ON [qan].[OsatBuildCriteriaSetReviewEmails] ([VersionId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewEmails_SnapshotReviewStageId] ON [qan].[OsatBuildCriteriaSetReviewEmails] ([SnapshotReviewStageId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewEmails_ReviewStageId] ON [qan].[OsatBuildCriteriaSetReviewEmails] ([ReviewStageId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewEmails_SnapshotReviewGroupId] ON [qan].[OsatBuildCriteriaSetReviewEmails] ([SnapshotReviewGroupId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewEmails_ReviewGroupId] ON [qan].[OsatBuildCriteriaSetReviewEmails] ([ReviewGroupId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewEmails_BatchId] ON [qan].[OsatBuildCriteriaSetReviewEmails] ([BatchId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewEmails_EmailTemplateId] ON [qan].[OsatBuildCriteriaSetReviewEmails] ([EmailTemplateId])
