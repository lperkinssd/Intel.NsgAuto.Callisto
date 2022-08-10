CREATE TABLE [qan].[OsatBuildCriteriaSetReviewStages] (
    [Id]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]        BIGINT        NOT NULL,
    [ReviewStageId]    INT           NOT NULL,
    [StageName]        VARCHAR (50)  NOT NULL,
    [DisplayName]      VARCHAR (100) NOT NULL,
    [Sequence]         INT           NOT NULL,
    [ParentStageId]    INT           NULL,
    [IsNextInParallel] BIT           NULL,
    CONSTRAINT [PK_OsatBuildCriteriaSetReviewStages] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatBuildCriteriaSetReviewStages_VersionId_ReviewStageId] UNIQUE NONCLUSTERED ([VersionId] ASC, [ReviewStageId] ASC)
);

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewStages_VersionId] ON [qan].[OsatBuildCriteriaSetReviewStages] ([VersionId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewStages_ReviewStageId] ON [qan].[OsatBuildCriteriaSetReviewStages] ([ReviewStageId])
