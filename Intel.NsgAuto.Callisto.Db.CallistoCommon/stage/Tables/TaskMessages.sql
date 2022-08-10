CREATE TABLE [stage].[TaskMessages] (
    [Id]        BIGINT          IDENTITY (1, 1) NOT NULL,
    [TaskId]    BIGINT          NOT NULL,
    [Type]      VARCHAR (20)    NULL,
    [Text]      NVARCHAR (4000) NULL,
    [CreatedOn] DATETIME2 (7)   CONSTRAINT [DF_TaskMessages_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_TaskMessages] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_TaskMessages_TaskId] ON [stage].[TaskMessages] ([TaskId] ASC)
