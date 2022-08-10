CREATE TABLE [qan].[MMRecipeReviewers] (
    [Id]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]     BIGINT        NOT NULL,
    [ReviewStageId] INT           NOT NULL,
    [ReviewGroupId] INT           NOT NULL,
    [ReviewerId]    INT           NOT NULL,
    [Name]          VARCHAR (255) NOT NULL,
    [Idsid]         VARCHAR (50)  NOT NULL,
    [Wwid]          VARCHAR (10)  NOT NULL,
    [Email]         VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_MMRecipeReviewers] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_MMRecipeReviewers_VersionId_ReviewStageId_ReviewGroupId_ReviewerId] UNIQUE NONCLUSTERED ([VersionId] ASC, [ReviewStageId]ASC, [ReviewGroupId] ASC, [ReviewerId] ASC)
);

GO

CREATE INDEX [IX_MMRecipeReviewers_VersionId] ON [qan].[MMRecipeReviewers] ([VersionId])

GO

CREATE INDEX [IX_MMRecipeReviewers_ReviewStageId] ON [qan].[MMRecipeReviewers] ([ReviewStageId])

GO

CREATE INDEX [IX_MMRecipeReviewers_ReviewGroupId] ON [qan].[MMRecipeReviewers] ([ReviewGroupId])

GO

CREATE INDEX [IX_MMRecipeReviewers_ReviewerId] ON [qan].[MMRecipeReviewers] ([ReviewerId])

GO

CREATE INDEX [IX_MMRecipeReviewers_Idsid] ON [qan].[MMRecipeReviewers] ([Idsid])

GO

CREATE INDEX [IX_MMRecipeReviewers_Wwid] ON [qan].[MMRecipeReviewers] ([Wwid])

GO

CREATE INDEX [IX_MMRecipeReviewers_Email] ON [qan].[MMRecipeReviewers] ([Email])
