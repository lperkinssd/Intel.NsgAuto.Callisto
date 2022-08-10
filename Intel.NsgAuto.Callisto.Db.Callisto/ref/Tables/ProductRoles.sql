CREATE TABLE [ref].[ProductRoles] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (255) NOT NULL,
    [Process]   VARCHAR (255) NULL,
    [IsActive]  BIT           CONSTRAINT [DF_ProductRoles_IsActive] DEFAULT ((1)) NOT NULL,
    [PCN]       BIT           NULL,
    [CreatedBy] VARCHAR (25)  NOT NULL,
    [CreatedOn] DATETIME2 (7) CONSTRAINT [DF_ProductRoles_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy] VARCHAR (25)  NOT NULL,
    [UpdatedOn] DATETIME2 (7) CONSTRAINT [DF_ProductRoles_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ProductRoles] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_ProductRoles_Name_Process] UNIQUE NONCLUSTERED ([Name] ASC, [Process] ASC)
);



