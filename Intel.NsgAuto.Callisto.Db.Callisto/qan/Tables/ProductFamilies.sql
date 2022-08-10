CREATE TABLE [qan].[ProductFamilies] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (50)  NOT NULL,
    [NameSpeed] VARCHAR (50)  NULL,
    [CreatedBy] VARCHAR (25)  NOT NULL,
    [CreatedOn] DATETIME2 (7) CONSTRAINT [DF_ProductFamilies_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy] VARCHAR (25)  NOT NULL,
    [UpdatedOn] DATETIME2 (7) CONSTRAINT [DF_ProductFamilies_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ProductFamilies] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_ProductFamilies_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);

GO

CREATE INDEX [IX_ProductFamilies_NameSpeed] ON [qan].[ProductFamilies] ([NameSpeed])
