CREATE TABLE [ref].[AccountSubsidiaries] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (255) NOT NULL,
    [Process]   VARCHAR (25)  NULL,
    [IsActive]  BIT           NOT NULL,
    [CreatedBy] VARCHAR (25)  NOT NULL,
    [CreatedOn] DATETIME2 (7) NOT NULL,
    [UpdatedBy] VARCHAR (25)  NOT NULL,
    [UpdatedOn] DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_AccountSubsidiaries] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [DF_AccountSubsidiaries_Name_process] UNIQUE NONCLUSTERED ([Name] ASC, [Process] ASC)
);

