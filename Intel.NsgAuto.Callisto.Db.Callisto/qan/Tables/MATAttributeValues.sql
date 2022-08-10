CREATE TABLE [qan].[MATAttributeValues] (
    [Id]              INT           IDENTITY (1, 1) NOT NULL,
    [MATId]           INT           NOT NULL,
    [AttributeTypeId] INT           NOT NULL,
    [Value]           VARCHAR (MAX) NOT NULL,
    [Operator]        VARCHAR (255) NULL,
    [DataType]        VARCHAR (255) NULL,
    [CreatedBy]       VARCHAR (25)  NULL,
    [CreatedOn]       DATETIME2 (7) CONSTRAINT [DF_MATAttributeValues_CreatedOn] DEFAULT (getutcdate()) NULL,
    [UpdatedBy]       VARCHAR (25)  NULL,
    [UpdatedOn]       DATETIME2 (7) CONSTRAINT [DF_MATAttributeValues_UpdatedOn] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_MATAttributeValues] PRIMARY KEY CLUSTERED ([Id] ASC)
);



