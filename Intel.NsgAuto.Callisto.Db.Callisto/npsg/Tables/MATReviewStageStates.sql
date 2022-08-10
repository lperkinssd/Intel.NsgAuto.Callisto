CREATE TABLE [npsg].[MATReviewStageStates] (
    [VersionId]       INT NOT NULL,
    [ReviewStageId]   INT NOT NULL,
    [IsActive]        BIT NOT NULL,
    [HasEmailSent]    BIT NOT NULL,
    [HasBeenRejected] BIT NULL,
    CONSTRAINT [PK_NPSG_MATReviewStageStates] PRIMARY KEY CLUSTERED ([VersionId] ASC, [ReviewStageId] ASC) WITH (FILLFACTOR = 90)
);

