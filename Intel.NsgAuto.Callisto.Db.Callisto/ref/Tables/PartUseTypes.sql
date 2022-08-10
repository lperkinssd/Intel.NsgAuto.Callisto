CREATE TABLE [ref].[PartUseTypes] (
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (25) NOT NULL,
    [Abbreviation]  VARCHAR (5)  NOT NULL,
    CONSTRAINT [PK_PartUseTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_PartUseTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC),
    CONSTRAINT [U_PartUseTypes_Abbreviation] UNIQUE NONCLUSTERED ([Abbreviation] ASC)
);
