CREATE TABLE [qan].[MMRecipeReviewStages] (
    [Id]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]        BIGINT        NOT NULL,
    [ReviewStageId]    INT           NOT NULL,
    [StageName]        VARCHAR (50)  NOT NULL,
    [DisplayName]      VARCHAR (100) NOT NULL,
    [Sequence]         INT           NOT NULL,
    [ParentStageId]    INT           NULL,
    [IsNextInParallel] BIT           NULL,
    CONSTRAINT [PK_MMRecipeReviewStages] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_MMRecipeReviewStages_VersionId_ReviewStageId] UNIQUE NONCLUSTERED ([VersionId] ASC, [ReviewStageId] ASC)
);

GO

CREATE INDEX [IX_MMRecipeReviewStages_VersionId] ON [qan].[MMRecipeReviewStages] ([VersionId])

GO

CREATE INDEX [IX_MMRecipeReviewStages_ReviewStageId] ON [qan].[MMRecipeReviewStages] ([ReviewStageId])
