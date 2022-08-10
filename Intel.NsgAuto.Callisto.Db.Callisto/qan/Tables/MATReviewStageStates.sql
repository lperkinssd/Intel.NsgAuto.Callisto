CREATE TABLE [qan].[MATReviewStageStates] (
    [VersionId]       INT NOT NULL,
    [ReviewStageId]   INT NOT NULL,
    [IsActive]        BIT NOT NULL,
    [HasEmailSent]    BIT NOT NULL,
    [HasBeenRejected] BIT NULL,
    CONSTRAINT [PK_MATReviewStageStates] PRIMARY KEY CLUSTERED ([VersionId] ASC, [ReviewStageId] ASC) WITH (FILLFACTOR = 90)
);

