CREATE TABLE [qan].[ReviewTypeReviewStages] (
    [Id]            INT IDENTITY (1, 1) NOT NULL,
    [ReviewTypeId]  INT NOT NULL,
    [ReviewStageId] INT NOT NULL,
    [CreatedBy]     VARCHAR (25)  NOT NULL,
    [CreatedOn]     DATETIME2 (7) CONSTRAINT [DF_ReviewTypeReviewStages_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]     VARCHAR (25)  NOT NULL,
    [UpdatedOn]     DATETIME2 (7) CONSTRAINT [DF_ReviewTypeReviewStages_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ReviewTypeReviewStages] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_ReviewTypeReviewStages_ReviewTypeId_ReviewStageId] UNIQUE NONCLUSTERED ([ReviewTypeId] ASC, [ReviewStageId] ASC)
);

GO

CREATE INDEX [IX_ReviewTypeReviewStages_ReviewTypeId] ON [qan].[ReviewTypeReviewStages] ([ReviewTypeId])

GO

CREATE INDEX [IX_ReviewTypeReviewStages_ReviewStageId] ON [qan].[ReviewTypeReviewStages] ([ReviewStageId])
