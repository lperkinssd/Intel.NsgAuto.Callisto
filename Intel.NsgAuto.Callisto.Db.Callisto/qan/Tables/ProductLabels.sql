CREATE TABLE [qan].[ProductLabels] (
    [Id]                          BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProductLabelSetVersionId]    INT           NOT NULL,
    [ProductionProductCode]       VARCHAR (25)  NOT NULL,
    [ProductFamilyId]             INT           NULL,
    [CustomerId]                  INT           NULL,
    [ProductFamilyNameSeriesId]   INT           NULL,
    [Capacity]                    VARCHAR (50)  NULL,
    [ModelString]                 VARCHAR (50)  NULL,
    [VoltageCurrent]              VARCHAR (50)  NULL,
    [InterfaceSpeed]              VARCHAR (50)  NULL,
    [OpalTypeId]                  INT           NULL,
    [KCCId]                       VARCHAR (50)  NULL,
    [CanadianStringClass]         VARCHAR (50)  NULL,
    [CreatedBy]                   VARCHAR (25)  NOT NULL,
    [CreatedOn]                   DATETIME2 (7) CONSTRAINT [DF_ProductLabels_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]                   VARCHAR (25)  NOT NULL,
    [UpdatedOn]                   DATETIME2 (7) CONSTRAINT [DF_ProductLabels_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ProductLabels] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_ProductLabels_ProductLabelSetVersionId] ON [qan].[ProductLabels] ([ProductLabelSetVersionId])

GO

CREATE INDEX [IX_ProductLabels_ProductionProductCode] ON [qan].[ProductLabels] ([ProductionProductCode])

GO

CREATE INDEX [IX_ProductLabels_ProductFamilyId] ON [qan].[ProductLabels] ([ProductFamilyId])

GO

CREATE INDEX [IX_ProductLabels_CustomerId] ON [qan].[ProductLabels] ([CustomerId])
