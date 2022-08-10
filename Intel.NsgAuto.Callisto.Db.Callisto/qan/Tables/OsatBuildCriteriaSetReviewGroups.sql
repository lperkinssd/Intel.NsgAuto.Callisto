CREATE TABLE [qan].[OsatBuildCriteriaSetReviewGroups] (
    [Id]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]      BIGINT        NOT NULL,
    [ReviewStageId]  INT           NOT NULL,
    [ReviewGroupId]  INT           NOT NULL,
    [GroupName]      VARCHAR (50)  NOT NULL,
    [DisplayName]    VARCHAR (100) NULL,
    CONSTRAINT [PK_OsatBuildCriteriaSetReviewGroups] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatBuildCriteriaSetReviewGroups_VersionId_ReviewStageId_ReviewGroupId] UNIQUE NONCLUSTERED ([VersionId] ASC, [ReviewStageId]ASC, [ReviewGroupId] ASC)
);

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewGroups_VersionId] ON [qan].[OsatBuildCriteriaSetReviewGroups] ([VersionId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewGroups_ReviewStageId] ON [qan].[OsatBuildCriteriaSetReviewGroups] ([ReviewStageId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSetReviewGroups_ReviewGroupId] ON [qan].[OsatBuildCriteriaSetReviewGroups] ([ReviewGroupId])
