CREATE TABLE [qan].[OsatPasCombinations] (
      [Id]                     INT IDENTITY (1, 1) NOT NULL
    , [OsatId]                 INT                 NOT NULL
    , [DesignFamilyId]         INT                 NOT NULL
    , [CreatedBy]              VARCHAR   (25)      NOT NULL
    , [CreatedOn]              DATETIME2 (7)       NOT NULL CONSTRAINT [DF_OsatPasCombinations_CreatedOn] DEFAULT (getutcdate())
    , [UpdatedBy]              VARCHAR   (25)      NOT NULL
    , [UpdatedOn]              DATETIME2 (7)       NOT NULL CONSTRAINT [DF_OsatPasCombinations_UpdatedOn] DEFAULT (getutcdate())
    , CONSTRAINT [PK_OsatPasCombinations] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_OsatPasCombinations_DesignId_FabricationFacilityId_TestFlowId_ProbeConversionId] UNIQUE NONCLUSTERED ([OsatId], [DesignFamilyId])
);

GO

CREATE INDEX [IX_OsatPasCombinations_OsatId] ON [qan].[OsatPasCombinations] ([OsatId])

GO

CREATE INDEX [IX_OsatPasCombinations_DesignFamilyId] ON [qan].[OsatPasCombinations] ([DesignFamilyId])
