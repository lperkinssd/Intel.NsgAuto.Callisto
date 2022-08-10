CREATE TABLE [qan].[MMRecipeReviewEmails] (
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
    CONSTRAINT [PK_MMRecipeReviewEmails] PRIMARY KEY CLUSTERED ([Id] ASC),
);

GO

CREATE INDEX [IX_MMRecipeReviewEmails_VersionId] ON [qan].[MMRecipeReviewEmails] ([VersionId])

GO

CREATE INDEX [IX_MMRecipeReviewEmails_SnapshotReviewStageId] ON [qan].[MMRecipeReviewEmails] ([SnapshotReviewStageId])

GO

CREATE INDEX [IX_MMRecipeReviewEmails_ReviewStageId] ON [qan].[MMRecipeReviewEmails] ([ReviewStageId])

GO

CREATE INDEX [IX_MMRecipeReviewEmails_SnapshotReviewGroupId] ON [qan].[MMRecipeReviewEmails] ([SnapshotReviewGroupId])

GO

CREATE INDEX [IX_MMRecipeReviewEmails_ReviewGroupId] ON [qan].[MMRecipeReviewEmails] ([ReviewGroupId])

GO

CREATE INDEX [IX_MMRecipeReviewEmails_BatchId] ON [qan].[MMRecipeReviewEmails] ([BatchId])

GO

CREATE INDEX [IX_MMRecipeReviewEmails_EmailTemplateId] ON [qan].[MMRecipeReviewEmails] ([EmailTemplateId])
