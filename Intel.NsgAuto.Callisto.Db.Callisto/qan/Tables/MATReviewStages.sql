CREATE TABLE [qan].[MATReviewStages] (
    [Id]               INT           NOT NULL,
    [VersionId]        INT           NOT NULL,
    [StageName]        VARCHAR (50)  NOT NULL,
    [DisplayName]      VARCHAR (100) NOT NULL,
    [StageSequence]    INT           NOT NULL,
    [ParentStageId]    INT           NULL,
    [IsNextInParallel] BIT           NULL,
    CONSTRAINT [PK_MATReviewStages] PRIMARY KEY CLUSTERED ([Id] ASC, [VersionId] ASC)
);





