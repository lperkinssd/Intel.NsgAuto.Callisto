CREATE TABLE [qan].[AcBuildCriteriaReviewStages] (
    [Id]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]        BIGINT        NOT NULL,
    [ReviewStageId]    INT           NOT NULL,
    [StageName]        VARCHAR (50)  NOT NULL,
    [DisplayName]      VARCHAR (100) NOT NULL,
    [Sequence]         INT           NOT NULL,
    [ParentStageId]    INT           NULL,
    [IsNextInParallel] BIT           NULL,
    CONSTRAINT [PK_AcBuildCriteriaReviewStages] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_AcBuildCriteriaReviewStages_VersionId_ReviewStageId] UNIQUE NONCLUSTERED ([VersionId] ASC, [ReviewStageId] ASC)
);

GO

CREATE INDEX [IX_AcBuildCriteriaReviewStages_VersionId] ON [qan].[AcBuildCriteriaReviewStages] ([VersionId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewStages_ReviewStageId] ON [qan].[AcBuildCriteriaReviewStages] ([ReviewStageId])
