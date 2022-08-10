CREATE TABLE [qan].[PreferredRole] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [UserId]     VARCHAR (50)  NOT NULL,
    [ActiveRole] VARCHAR (50)  NOT NULL,
    [CreatedOn]  DATETIME2 (7) NOT NULL,
    [UpdatedOn]  DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_qan.PreferredRole] PRIMARY KEY CLUSTERED ([Id] ASC)
);

