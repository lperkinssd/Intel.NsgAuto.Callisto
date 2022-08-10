CREATE TABLE [qan].[UserRoles] (
    [WWID]     VARCHAR (20)  NOT NULL,
    [IdSid]    VARCHAR (15)  NOT NULL,
    [RoleName] VARCHAR (500) NOT NULL
);


GO

CREATE INDEX [IX_UserRoles_WWID] ON [qan].[UserRoles] ([WWID])

GO

CREATE INDEX [IX_UserRoles_IdSid] ON [qan].[UserRoles] ([IdSid])