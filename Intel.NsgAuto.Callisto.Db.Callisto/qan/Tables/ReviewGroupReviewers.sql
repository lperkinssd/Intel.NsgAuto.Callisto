CREATE TABLE [qan].[ReviewGroupReviewers] (
    [Id]                       INT IDENTITY (1, 1) NOT NULL,
    [ReviewStageReviewGroupId] INT NOT NULL,
    [ReviewerId]               INT NOT NULL,
    [CreatedBy]                VARCHAR (25)  NOT NULL,
    [CreatedOn]                DATETIME2 (7) CONSTRAINT [DF_ReviewGroupReviewers_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]                VARCHAR (25)  NOT NULL,
    [UpdatedOn]                DATETIME2 (7) CONSTRAINT [DF_ReviewGroupReviewers_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ReviewGroupReviewers] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_ReviewGroupReviewers_ReviewStageReviewGroupId_ReviewerId] UNIQUE NONCLUSTERED ([ReviewStageReviewGroupId] ASC, [ReviewerId] ASC)
);
