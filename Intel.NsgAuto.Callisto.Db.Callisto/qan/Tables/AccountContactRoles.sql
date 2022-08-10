CREATE TABLE [qan].[AccountContactRoles] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [RoleId]    INT           NOT NULL,
    [ContactId] INT           NOT NULL,
    [IsActive]  BIT           NOT NULL,
    [CreatedBy] VARCHAR (25)  NOT NULL,
    [CreatedOn] DATETIME2 (7) NOT NULL,
    [UpdatedBy] VARCHAR (25)  NOT NULL,
    [UpdatedOn] DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_AccountContactRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_AccountContactRoles_RoleId]
    ON [qan].[AccountContactRoles]([RoleId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_AccountContactRoles_ContactId]
    ON [qan].[AccountContactRoles]([ContactId] ASC);

