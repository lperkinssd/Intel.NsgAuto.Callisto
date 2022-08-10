CREATE TABLE [npsg].[MATReviewDecisions] (
    [VersionId]        INT            NOT NULL,
    [ReviewStageId]    INT            NOT NULL,
    [ReviewGroupId]    INT            NOT NULL,
    [ReviewReviewerId] INT            NOT NULL,
    [IsApproved]       BIT            NOT NULL,
    [Comment]          VARCHAR (1000) NULL,
    [ReviewedOn]       DATETIME2 (7)  CONSTRAINT [DF_NPSG_MATReviewDecisions_ReviewedOn] DEFAULT (getutcdate()) NOT NULL
);

