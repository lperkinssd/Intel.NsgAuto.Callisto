CREATE TABLE [qan].[AcAttributeTypes] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (50)  NOT NULL,
    [NameDisplay]  VARCHAR (50)  NOT NULL,
    [DataTypeId]   INT           NOT NULL,
    [CreatedBy]    VARCHAR (25)  NOT NULL,
    [CreatedOn]    DATETIME2 (7) CONSTRAINT [DF_AcAttributeTypes_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]    VARCHAR (25)  NOT NULL,
    [UpdatedOn]    DATETIME2 (7) CONSTRAINT [DF_AcAttributeTypes_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_AcAttributeTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_AcAttributeTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC),
    CONSTRAINT [U_AcAttributeTypes_NameDisplay] UNIQUE NONCLUSTERED ([NameDisplay] ASC)
);
