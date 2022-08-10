CREATE TABLE [ref].[AccountRoles] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (255) NOT NULL,
    [IsActive]  BIT           NOT NULL,
    [PCN]       BIT           NULL,
    [Process]   VARCHAR (25)  NULL,
    [CreatedBy] VARCHAR (25)  NOT NULL,
    [CreatedOn] DATETIME2 (7) NOT NULL,
    [UpdatedBy] VARCHAR (25)  NOT NULL,
    [UpdatedOn] DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_AccountRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);



