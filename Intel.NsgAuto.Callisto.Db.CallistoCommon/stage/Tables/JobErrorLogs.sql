CREATE TABLE [stage].[JobErrorLogs] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [JobId]          INT           NOT NULL,
    [JobExecutionId] INT           NULL,
    [JobStepId]      INT           NULL,
    [ErrorDateTime]  DATETIME2 (7) NOT NULL,
    [ErrorMessage]   VARCHAR (MAX) NOT NULL,
    [ErrorCode]      VARCHAR (10)  NULL,
    CONSTRAINT [PK_JobErrorLogs] PRIMARY KEY CLUSTERED ([Id] ASC)
);

