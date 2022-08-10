CREATE TABLE [ref].[DesignFamilies] (
    [Id]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (10) NOT NULL,
    CONSTRAINT [PK_ProductFamilies] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_DesignFamilies_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);




