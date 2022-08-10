CREATE TABLE [npsg].[MATReviewChangeHistory] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [VersionId]   INT           NOT NULL,
    [Description] VARCHAR (MAX) NOT NULL,
    [ChangedBy]   VARCHAR (50)  NOT NULL,
    [ChangedOn]   DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_NPSG_MATReviewChangeHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

