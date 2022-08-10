CREATE TABLE [qan].[ProductLabelReviewStageStates] (
    [VersionId]       INT NOT NULL,
    [ReviewStageId]   INT NOT NULL,
    [IsActive]        BIT NOT NULL,
    [HasEmailSent]    BIT NOT NULL,
    [HasBeenRejected] BIT NULL,
    CONSTRAINT [PK_ProductLabelReviewStageStates] PRIMARY KEY CLUSTERED ([VersionId] ASC, [ReviewStageId] ASC) WITH (FILLFACTOR = 90)
);

