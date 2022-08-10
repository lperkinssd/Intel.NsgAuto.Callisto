CREATE TABLE [ref].[AccountClients] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (255) NOT NULL,
    [Process]   VARCHAR (255) NOT NULL,
    [IsActive]  BIT           NOT NULL,
    [CreatedBy] VARCHAR (25)  NOT NULL,
    [CreatedOn] DATETIME2 (7) NOT NULL,
    [UpdatedBy] VARCHAR (25)  NOT NULL,
    [UpdatedOn] DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_AccountClients] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [DF_AccountClients_Name_process] UNIQUE NONCLUSTERED ([Name] ASC, [Process] ASC)
);

