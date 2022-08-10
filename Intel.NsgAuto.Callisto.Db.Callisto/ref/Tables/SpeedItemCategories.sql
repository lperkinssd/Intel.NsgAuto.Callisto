CREATE TABLE [ref].[SpeedItemCategories] (
    [Id]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NOT NULL,
    [Code] VARCHAR (25) NOT NULL,
    CONSTRAINT [PK_SpeedItemCategories] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_SpeedItemCategories_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);

GO

CREATE INDEX [IX_SpeedItemCategories_Code] ON [ref].[SpeedItemCategories] ([Code])
