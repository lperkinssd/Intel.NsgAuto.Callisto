CREATE TABLE [qan].[AcBuildCombinations] (
      [Id]                     INT IDENTITY (1, 1) NOT NULL
    , [Name]                   VARCHAR(200)        NOT NULL
    , [DesignId]               INT                 NOT NULL
    , [FabricationFacilityId]  INT                 NOT NULL
    , [TestFlowId]             INT                 NULL
    , [ProbeConversionId]      INT                 NULL
    , [CreatedBy]              VARCHAR   (25)      NOT NULL
    , [CreatedOn]              DATETIME2 (7)       NOT NULL CONSTRAINT [DF_AcBuildCombinations_CreatedOn] DEFAULT (getutcdate())
    , [UpdatedBy]              VARCHAR   (25)      NOT NULL
    , [UpdatedOn]              DATETIME2 (7)       NOT NULL CONSTRAINT [DF_AcBuildCombinations_UpdatedOn] DEFAULT (getutcdate())
    , CONSTRAINT [PK_AcBuildCombinations] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_AcBuildCombinations_Name] UNIQUE NONCLUSTERED ([Name])
    , CONSTRAINT [U_AcBuildCombinations_DesignId_FabricationFacilityId_TestFlowId_ProbeConversionId] UNIQUE NONCLUSTERED ([DesignId], [FabricationFacilityId], [TestFlowId], [ProbeConversionId])
);

GO

CREATE INDEX [IX_AcBuildCombinations_DesignId] ON [qan].[AcBuildCombinations] ([DesignId])

GO

CREATE INDEX [IX_AcBuildCombinations_FabricationFacilityId] ON [qan].[AcBuildCombinations] ([FabricationFacilityId])

GO

CREATE INDEX [IX_AcBuildCombinations_TestFlowId] ON [qan].[AcBuildCombinations] ([TestFlowId])

GO

CREATE INDEX [IX_AcBuildCombinations_ProbeConversionId] ON [qan].[AcBuildCombinations] ([ProbeConversionId])
