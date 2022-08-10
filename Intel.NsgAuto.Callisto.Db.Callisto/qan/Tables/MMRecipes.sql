CREATE TABLE [qan].[MMRecipes] (
      [Id]                    BIGINT        IDENTITY (1, 1) NOT NULL
    , [Version]               INT           NOT NULL
    , [IsPOR]                 BIT           CONSTRAINT [DF_MMRecipes_IsPOR] DEFAULT (0) NOT NULL
    , [IsActive]              BIT           CONSTRAINT [DF_MMRecipes_IsActive] DEFAULT (1) NOT NULL
    , [StatusId]              INT           NOT NULL
    , [CreatedBy]             VARCHAR (25)  NOT NULL
    , [CreatedOn]             DATETIME2 (7) CONSTRAINT [DF_MMRecipes_CreatedOn] DEFAULT (getutcdate()) NOT NULL
    , [UpdatedBy]             VARCHAR (25)  NOT NULL
    , [UpdatedOn]             DATETIME2 (7) CONSTRAINT [DF_MMRecipes_UpdatedOn] DEFAULT (getutcdate()) NOT NULL
    , [PCode]                 VARCHAR (10)  NOT NULL
    , [ProductName]           VARCHAR (200) NULL
    , [ProductFamilyId]       INT           NULL
    , [MOQ]                   INT           NULL
    , [ProductionProductCode] VARCHAR (25)  NULL
    , [SCode]                 VARCHAR (10)  NULL
    , [FormFactorId]          INT           NULL
    , [CustomerId]            INT           NULL
    , [PRQDate]               DATETIME2 (7) NULL
    , [CustomerQualStatusId]  INT           NULL
    , [SCodeProductCode]      VARCHAR (20)  NULL
    , [ModelString]           VARCHAR (20)  NULL
    , [PLCStageId]            INT           NULL
    , [ProductLabelId]        BIGINT        NULL
    , [SubmittedBy]           VARCHAR (25)  NULL
    , [SubmittedOn]           DATETIME2 (7) NULL
    CONSTRAINT [PK_MMRecipes] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_MMRecipes_IsPOR] ON [qan].[MMRecipes] ([IsPOR])

GO

CREATE INDEX [IX_MMRecipes_IsActive] ON [qan].[MMRecipes] ([IsActive])

GO

CREATE INDEX [IX_MMRecipes_StatusId] ON [qan].[MMRecipes] ([StatusId])

GO

CREATE INDEX [IX_MMRecipes_PCode] ON [qan].[MMRecipes] ([PCode])

GO

CREATE INDEX [IX_MMRecipes_ProductFamilyId] ON [qan].[MMRecipes] ([ProductFamilyId])

GO

CREATE INDEX [IX_MMRecipes_ProductionProductCode] ON [qan].[MMRecipes] ([ProductionProductCode])

GO

CREATE INDEX [IX_MMRecipes_SCode] ON [qan].[MMRecipes] ([SCode])

GO

CREATE INDEX [IX_MMRecipes_ProductLabelId] ON [qan].[MMRecipes] ([ProductLabelId])
