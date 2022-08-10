CREATE TABLE [qan].[ProductLabelAttributes] (
    [Id]              BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProductLabelId]  BIGINT        NOT NULL,
    [AttributeTypeId] INT           NOT NULL,
    [Value]           VARCHAR (500) NULL,
    [CreatedBy]       VARCHAR (25)  NOT NULL,
    [CreatedOn]       DATETIME2 (7) CONSTRAINT [DF_ProductLabelAttributes_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]       VARCHAR (25)  NOT NULL,
    [UpdatedOn]       DATETIME2 (7) CONSTRAINT [DF_ProductLabelAttributes_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ProductLabelAttributes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_ProductLabelAttributes_ProductLabelId_AttributeTypeId] UNIQUE NONCLUSTERED ([ProductLabelId] ASC, [AttributeTypeId] ASC)
);

GO

CREATE INDEX [IX_ProductLabelAttributes_ProductLabelId] ON [qan].[ProductLabelAttributes] ([ProductLabelId])

GO

CREATE INDEX [IX_ProductLabelAttributes_AttributeTypeId] ON [qan].[ProductLabelAttributes] ([AttributeTypeId])
