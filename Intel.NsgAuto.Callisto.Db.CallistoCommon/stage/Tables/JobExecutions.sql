CREATE TABLE [stage].[JobExecutions] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [JobId]         INT           NOT NULL,
    [JobStatus]     VARCHAR (50)  NOT NULL,
    [StartDateTime] DATETIME2 (7) CONSTRAINT [DF_JobExecutions_StartDateTime] DEFAULT (getutcdate()) NOT NULL,
    [EndDateTime]   DATETIME2 (7) NULL,
    CONSTRAINT [PK_JobExecutions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

