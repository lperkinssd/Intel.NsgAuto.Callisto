CREATE TABLE [qan].[AcBuildCriteriaReviewers] (
    [Id]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]     BIGINT        NOT NULL,
    [ReviewStageId] INT           NOT NULL,
    [ReviewGroupId] INT           NOT NULL,
    [ReviewerId]    INT           NOT NULL,
    [Name]          VARCHAR (255) NOT NULL,
    [Idsid]         VARCHAR (50)  NOT NULL,
    [Wwid]          VARCHAR (10)  NOT NULL,
    [Email]         VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_AcBuildCriteriaReviewers] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_AcBuildCriteriaReviewers_VersionId_ReviewStageId_ReviewGroupId_ReviewerId] UNIQUE NONCLUSTERED ([VersionId] ASC, [ReviewStageId]ASC, [ReviewGroupId] ASC, [ReviewerId] ASC)
);

GO

CREATE INDEX [IX_AcBuildCriteriaReviewers_VersionId] ON [qan].[AcBuildCriteriaReviewers] ([VersionId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewers_ReviewStageId] ON [qan].[AcBuildCriteriaReviewers] ([ReviewStageId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewers_ReviewGroupId] ON [qan].[AcBuildCriteriaReviewers] ([ReviewGroupId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewers_ReviewerId] ON [qan].[AcBuildCriteriaReviewers] ([ReviewerId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewers_Idsid] ON [qan].[AcBuildCriteriaReviewers] ([Idsid])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewers_Wwid] ON [qan].[AcBuildCriteriaReviewers] ([Wwid])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewers_Email] ON [qan].[AcBuildCriteriaReviewers] ([Email])
