CREATE TABLE [qan].[OsatBuildCriteriaSetReviewers] (
    [Id]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]     BIGINT        NOT NULL,
    [ReviewStageId] INT           NOT NULL,
    [ReviewGroupId] INT           NOT NULL,
    [ReviewerId]    INT           NOT NULL,
    [Name]          VARCHAR (255) NOT NULL,
    [Idsid]         VARCHAR (50)  NOT NULL,
    [Wwid]          VARCHAR (10)  NOT NULL,
    [Email]         VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_OsatBuildCriteriaSetReviewers] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatBuildCriteriaSetReviewers_VersionId_ReviewStageId_ReviewGroupId_ReviewerId] UNIQUE NONCLUSTERED ([VersionId] ASC, [ReviewStageId]ASC, [ReviewGroupId] ASC, [ReviewerId] ASC)
);

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewers_VersionId] ON [qan].[OsatBuildCriteriaSetReviewers] ([VersionId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewers_ReviewStageId] ON [qan].[OsatBuildCriteriaSetReviewers] ([ReviewStageId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewers_ReviewGroupId] ON [qan].[OsatBuildCriteriaSetReviewers] ([ReviewGroupId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewers_ReviewerId] ON [qan].[OsatBuildCriteriaSetReviewers] ([ReviewerId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewers_Idsid] ON [qan].[OsatBuildCriteriaSetReviewers] ([Idsid])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewers_Wwid] ON [qan].[OsatBuildCriteriaSetReviewers] ([Wwid])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewers_Email] ON [qan].[OsatBuildCriteriaSetReviewers] ([Email])
