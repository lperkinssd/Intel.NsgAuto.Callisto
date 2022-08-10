CREATE TABLE [qan].[AcBuildCriteriaReviewGroups] (
    [Id]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]      BIGINT        NOT NULL,
    [ReviewStageId]  INT           NOT NULL,
    [ReviewGroupId]  INT           NOT NULL,
    [GroupName]      VARCHAR (50)  NOT NULL,
    [DisplayName]    VARCHAR (100) NULL,
    CONSTRAINT [PK_AcBuildCriteriaReviewGroups] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_AcBuildCriteriaReviewGroups_VersionId_ReviewStageId_ReviewGroupId] UNIQUE NONCLUSTERED ([VersionId] ASC, [ReviewStageId]ASC, [ReviewGroupId] ASC)
);

GO

CREATE INDEX [IX_AcBuildCriteriaReviewGroups_VersionId] ON [qan].[AcBuildCriteriaReviewGroups] ([VersionId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewGroups_ReviewStageId] ON [qan].[AcBuildCriteriaReviewGroups] ([ReviewStageId])

GO

CREATE INDEX [IX_AcBuildCriteriaReviewGroups_ReviewGroupId] ON [qan].[AcBuildCriteriaReviewGroups] ([ReviewGroupId])
