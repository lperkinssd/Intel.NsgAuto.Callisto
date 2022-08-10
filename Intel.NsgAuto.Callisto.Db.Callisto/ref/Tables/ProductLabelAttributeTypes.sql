CREATE TABLE [ref].[ProductLabelAttributeTypes] (
    [Id]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NOT NULL,
    [NameDisplay] VARCHAR (100) NOT NULL
    CONSTRAINT [PK_ProductLabelAttributeTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_ProductLabelAttributeTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
