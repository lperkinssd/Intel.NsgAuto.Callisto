CREATE TABLE [qan].[UserProcessRoles] (
    [WWID]     VARCHAR (20)  NOT NULL,
    [IdSid]    VARCHAR (15)  NOT NULL,
    [RoleName] VARCHAR (500) NOT NULL,
    [Process]  VARCHAR (25)  NOT NULL
);

GO

CREATE INDEX [IX_UserProcessRoles_WWID] ON [qan].[UserProcessRoles] ([WWID])

GO

CREATE INDEX [IX_UserProcessRoles_IdSid] ON [qan].[UserProcessRoles] ([IdSid])

GO

CREATE INDEX [IX_UserProcessRoles_Process] ON [qan].[UserProcessRoles] ([Process])
