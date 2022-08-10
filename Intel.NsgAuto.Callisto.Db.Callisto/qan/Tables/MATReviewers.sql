CREATE TABLE [qan].[MATReviewers] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [VersionId]     INT           NOT NULL,
    [ReviewStageId] INT           NOT NULL,
    [ReviewGroupId] INT           NOT NULL,
    [Name]          VARCHAR (255) NOT NULL,
    [Idsid]         VARCHAR (50)  NOT NULL,
    [Wwid]          VARCHAR (10)  NOT NULL,
    [Email]         VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_MATReviewers_1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

