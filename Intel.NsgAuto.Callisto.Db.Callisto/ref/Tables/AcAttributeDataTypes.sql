CREATE TABLE [ref].[AcAttributeDataTypes] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (50)  NOT NULL,
    [NameDisplay]  VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_AcAttributeDataTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_AcAttributeDataTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC),
    CONSTRAINT [U_AcAttributeDataTypes_NameDisplay] UNIQUE NONCLUSTERED ([NameDisplay] ASC)
);
