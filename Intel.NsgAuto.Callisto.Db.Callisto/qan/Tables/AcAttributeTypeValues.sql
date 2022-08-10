CREATE TABLE [qan].[AcAttributeTypeValues] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [AttributeTypeId]  INT           NOT NULL,
    [Value]            VARCHAR (50)  COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [ValueDisplay]     VARCHAR (50)  COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [CreatedBy]        VARCHAR (25)  NOT NULL,
    [CreatedOn]        DATETIME2 (7) CONSTRAINT [DF_AcAttributeTypeValues_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]        VARCHAR (25)  NOT NULL,
    [UpdatedOn]        DATETIME2 (7) CONSTRAINT [DF_AcAttributeTypeValues_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_AcAttributeTypeValues] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_AcAttributeTypeValues_AttributeTypeId_Value] UNIQUE NONCLUSTERED ([AttributeTypeId] ASC, [Value] ASC),
    CONSTRAINT [U_AcAttributeTypeValues_AttributeTypeId_ValueDisplay] UNIQUE NONCLUSTERED ([AttributeTypeId] ASC, [ValueDisplay] ASC)
);

GO

CREATE INDEX [IX_AcAttributeTypeValues_AttributeTypeId] ON [qan].[AcAttributeTypeValues] ([AttributeTypeId])
