CREATE TABLE [qan].[AcBuildCriteriaReviewEmails] (
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
    CONSTRAINT [PK_AcBuildCriteriaReviewEmails] PRIMARY KEY CLUSTERED ([Id] ASC),
);

GO

CREATE INDEX [IX_AcBuildCriteriaReviewEmails_VersionId] ON [qan].[AcBuildCriteriaReviewEmails] ([VersionId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewEmails_SnapshotReviewStageId] ON [qan].[AcBuildCriteriaReviewEmails] ([SnapshotReviewStageId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewEmails_ReviewStageId] ON [qan].[AcBuildCriteriaReviewEmails] ([ReviewStageId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewEmails_SnapshotReviewGroupId] ON [qan].[AcBuildCriteriaReviewEmails] ([SnapshotReviewGroupId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewEmails_ReviewGroupId] ON [qan].[AcBuildCriteriaReviewEmails] ([ReviewGroupId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewEmails_BatchId] ON [qan].[AcBuildCriteriaReviewEmails] ([BatchId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewEmails_EmailTemplateId] ON [qan].[AcBuildCriteriaReviewEmails] ([EmailTemplateId])
