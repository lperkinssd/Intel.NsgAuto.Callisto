CREATE TABLE [qan].[ProductCodeNames] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (255) NOT NULL,
    [Process]   VARCHAR (255) NULL,
    [IsActive]  BIT           CONSTRAINT [DF_ProductCodeNames_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedBy] VARCHAR (25)  NOT NULL,
    [CreatedOn] DATETIME2 (7) CONSTRAINT [DF_ProductCodeNames_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy] VARCHAR (25)  NOT NULL,
    [UpdatedOn] DATETIME2 (7) CONSTRAINT [DF_ProductCodeNames_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ProductCodeNames] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_ProductCodeNames_Name_Process] UNIQUE NONCLUSTERED ([Name] ASC, [Process] ASC)
);



