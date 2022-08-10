CREATE TABLE [stage].[Tasks] (
    [Id]                  BIGINT        IDENTITY (1, 1) NOT NULL,
    [TaskTypeId]          INT           NOT NULL,
    [JobExecutionId]      INT           NULL,
    [JobStepId]           INT           NULL,
    [Status]              VARCHAR (50)  NULL,
    [StartDateTime]       DATETIME2 (7) CONSTRAINT [DF_Tasks_StartDate] DEFAULT (getutcdate()) NOT NULL,
    [EndDateTime]         DATETIME2 (7) NULL,
    [AbortDateTime]       DATETIME2 (7) NULL,
    [ResolvedDateTime]    DATETIME2 (7) NULL,
    [ResolvedBy]          VARCHAR (25)  NULL,
    [ProgressPercent]     TINYINT       NULL,
    [ProgressText]        VARCHAR (200) NULL,
    CONSTRAINT [PK_Tasks] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CHK_Tasks_ProgressPercent] CHECK ([ProgressPercent]>=(0) AND [ProgressPercent]<=(100))
);

GO

CREATE INDEX [IX_Tasks_JobStepId] ON [stage].[Tasks] ([JobStepId] ASC)

GO

CREATE INDEX [IX_Tasks_JobExecutionId] ON [stage].[Tasks] ([JobExecutionId] ASC)

GO

CREATE INDEX [IX_Tasks_TaskTypeId] ON [stage].[Tasks] ([TaskTypeId] ASC)
