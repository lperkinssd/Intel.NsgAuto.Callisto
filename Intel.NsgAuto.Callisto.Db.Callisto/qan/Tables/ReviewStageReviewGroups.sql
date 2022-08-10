CREATE TABLE [qan].[ReviewStageReviewGroups] (
    [Id]                      INT IDENTITY (1, 1) NOT NULL,
    [ReviewTypeReviewStageId] INT NOT NULL,
    [ReviewGroupId]           INT NOT NULL,
    [CreatedBy]               VARCHAR (25)  NOT NULL,
    [CreatedOn]               DATETIME2 (7) CONSTRAINT [DF_ReviewStageReviewGroups_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]               VARCHAR (25)  NOT NULL,
    [UpdatedOn]               DATETIME2 (7) CONSTRAINT [DF_ReviewStageReviewGroups_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ReviewStageReviewGroups] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_ReviewStageReviewGroups_ReviewTypeReviewStageId_ReviewGroupId] UNIQUE NONCLUSTERED ([ReviewTypeReviewStageId] ASC, [ReviewGroupId] ASC)
);

GO

CREATE INDEX [IX_ReviewStageReviewGroups_ReviewTypeReviewStageId] ON [qan].[ReviewStageReviewGroups] ([ReviewTypeReviewStageId])

GO

CREATE INDEX [IX_ReviewStageReviewGroups_ReviewGroupId] ON [qan].[ReviewStageReviewGroups] ([ReviewGroupId])
