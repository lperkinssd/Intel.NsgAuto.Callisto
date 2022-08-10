CREATE TABLE [qan].[MMRecipeReviewGroups] (
    [Id]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]      BIGINT        NOT NULL,
    [ReviewStageId]  INT           NOT NULL,
    [ReviewGroupId]  INT           NOT NULL,
    [GroupName]      VARCHAR (50)  NOT NULL,
    [DisplayName]    VARCHAR (100) NULL,
    CONSTRAINT [PK_MMRecipeReviewGroups] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_MMRecipeReviewGroups_VersionId_ReviewStageId_ReviewGroupId] UNIQUE NONCLUSTERED ([VersionId] ASC, [ReviewStageId]ASC, [ReviewGroupId] ASC)
);

GO

CREATE INDEX [IX_MMRecipeReviewGroups_VersionId] ON [qan].[MMRecipeReviewGroups] ([VersionId])

GO

CREATE INDEX [IX_MMRecipeReviewGroups_ReviewStageId] ON [qan].[MMRecipeReviewGroups] ([ReviewStageId])

GO

CREATE INDEX [IX_MMRecipeReviewGroups_ReviewGroupId] ON [qan].[MMRecipeReviewGroups] ([ReviewGroupId])
