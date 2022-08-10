CREATE TABLE [stage].[JobSteps] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [JobId]          INT           NOT NULL,
    [JobExecutionId] INT           NULL,
    [JobStatus]      VARCHAR (50)  NOT NULL,
    [StartDateTime]  DATETIME2 (7) CONSTRAINT [DF_JobSteps_StartDateTime] DEFAULT (getutcdate()) NOT NULL,
    [EndDateTime]    DATETIME2 (7) NULL,
    CONSTRAINT [PK_JobLogs] PRIMARY KEY CLUSTERED ([Id] ASC)
);

