CREATE TABLE [qan].[AcAttributeDesignFamilies] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [AttributeId]    INT           NOT NULL,
    [DesignFamilyId] INT           NOT NULL,
    [CreatedBy]      VARCHAR (25)  NOT NULL,
    [CreatedOn]      DATETIME2 (7) DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]      VARCHAR (25)  NOT NULL,
    [UpdatedOn]      DATETIME2 (7) DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_AcAttributeDesignFamilies] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_AcAttributeDesignFamilies_AttributeDesign] UNIQUE NONCLUSTERED ([AttributeId] ASC, [DesignFamilyId] ASC)
);

