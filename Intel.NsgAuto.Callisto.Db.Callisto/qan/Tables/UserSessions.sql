CREATE TABLE [qan].[UserSessions] (
    [IdSid]     VARCHAR (15)  NOT NULL,
    [SessionId] VARCHAR (255) NOT NULL,
    [LoginTime] DATETIME2 (7) NOT NULL
);


GO

CREATE INDEX [IX_UserSessions_IdSid] ON [qan].[UserSessions] ([IdSid])

GO

CREATE INDEX [IX_UserSessions_SessionId] ON [qan].[UserSessions] ([SessionId])
