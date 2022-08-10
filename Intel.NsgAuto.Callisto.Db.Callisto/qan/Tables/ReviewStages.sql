CREATE TABLE [qan].[ReviewStages] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [StageName]        VARCHAR (100) NOT NULL,
    [DisplayName]      VARCHAR (100) NOT NULL,
    [IsActive]         BIT           CONSTRAINT [DF_ReviewStages_IsActive] DEFAULT ((1)) NOT NULL,
    [Sequence]         INT           NOT NULL,
    [ParentStageId]    INT           NULL,
    [IsNextInParallel] BIT           NULL,
    [CreatedBy]        VARCHAR (25)  NOT NULL,
    [CreatedOn]        DATETIME2 (7) CONSTRAINT [DF_ReviewStages_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]        VARCHAR (25)  NOT NULL,
    [UpdatedOn]        DATETIME2 (7) CONSTRAINT [DF_ReviewStages_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ReviewStages] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_ReviewStages_StageName] UNIQUE NONCLUSTERED ([StageName] ASC)
);
