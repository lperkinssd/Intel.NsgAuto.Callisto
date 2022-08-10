CREATE TABLE [qan].[UserActions] (
    [Id]                    BIGINT            IDENTITY (1, 1) NOT NULL,
    [CreatedBy]             VARCHAR (25)      NOT NULL,
    [CreatedOn]             DATETIME2 (7)     CONSTRAINT [DF_UserActions_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [Category]              VARCHAR (250)     NULL,
    [ActionType]            VARCHAR (100)     NULL,
    [Description]           VARCHAR (1000)    NULL,
    [EntityType]            VARCHAR (100)     NULL,
    [EntityId]              BIGINT            NULL,
    [EntityGuid]            UNIQUEIDENTIFIER  NULL,
    [Succeeded]             BIT               NULL,
    [Message]               VARCHAR (500)     NULL,
    [AssociatedEntityType]  VARCHAR (100)     NULL,
    [AssociatedEntityId]    BIGINT            NULL,
    CONSTRAINT [PK_UserActions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_UserActions_CreatedBy] ON [qan].[UserActions] ([CreatedBy])

GO

CREATE INDEX [IX_UserActions_Category] ON [qan].[UserActions] ([Category])

GO

CREATE INDEX [IX_UserActions_ActionType] ON [qan].[UserActions] ([ActionType])

GO

CREATE INDEX [IX_UserActions_EntityType] ON [qan].[UserActions] ([EntityType])

GO

CREATE INDEX [IX_UserActions_EntityId] ON [qan].[UserActions] ([EntityId])

GO

CREATE INDEX [IX_UserActions_EntityGuid] ON [qan].[UserActions] ([EntityGuid])

GO

CREATE INDEX [IX_UserActions_AssociatedEntityType] ON [qan].[UserActions] ([AssociatedEntityType])

GO

CREATE INDEX [IX_UserActions_AssociatedEntityId] ON [qan].[UserActions] ([AssociatedEntityId])
