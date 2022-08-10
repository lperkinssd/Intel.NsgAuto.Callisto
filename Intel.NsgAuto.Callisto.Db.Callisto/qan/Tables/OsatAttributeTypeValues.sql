CREATE TABLE [qan].[OsatAttributeTypeValues] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [AttributeTypeId]  INT           NOT NULL,
    [Value]            VARCHAR (50)  COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [ValueDisplay]     VARCHAR (50)  COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [CreatedBy]        VARCHAR (25)  NOT NULL,
    [CreatedOn]        DATETIME2 (7) CONSTRAINT [DF_OsatAttributeTypeValues_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]        VARCHAR (25)  NOT NULL,
    [UpdatedOn]        DATETIME2 (7) CONSTRAINT [DF_OsatAttributeTypeValues_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_OsatAttributeTypeValues] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatAttributeTypeValues_AttributeTypeId_Value] UNIQUE NONCLUSTERED ([AttributeTypeId] ASC, [Value] ASC),
    CONSTRAINT [U_OsatAttributeTypeValues_AttributeTypeId_ValueDisplay] UNIQUE NONCLUSTERED ([AttributeTypeId] ASC, [ValueDisplay] ASC)
);

GO

CREATE INDEX [IX_OsatAttributeTypeValues_AttributeTypeId] ON [qan].[OsatAttributeTypeValues] ([AttributeTypeId])
