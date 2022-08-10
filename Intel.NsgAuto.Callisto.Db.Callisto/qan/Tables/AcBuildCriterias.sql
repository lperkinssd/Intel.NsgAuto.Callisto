CREATE TABLE [qan].[AcBuildCriterias] (
      [Id]                    BIGINT        IDENTITY (1, 1) NOT NULL
    , [Version]               INT           NOT NULL
    , [IsPOR]                 BIT           CONSTRAINT [DF_AcBuildCriterias_IsPOR] DEFAULT (0) NOT NULL
    , [IsActive]              BIT           CONSTRAINT [DF_AcBuildCriterias_IsActive] DEFAULT (1) NOT NULL
    , [StatusId]              INT           NOT NULL
    , [CreatedBy]             VARCHAR (25)  NOT NULL
    , [CreatedOn]             DATETIME2 (7) CONSTRAINT [DF_AcBuildCriterias_CreatedOn] DEFAULT (getutcdate()) NOT NULL
    , [UpdatedBy]             VARCHAR (25)  NOT NULL
    , [UpdatedOn]             DATETIME2 (7) CONSTRAINT [DF_AcBuildCriterias_UpdatedOn] DEFAULT (getutcdate()) NOT NULL
    , [BuildCombinationId]    INT           NOT NULL
    , [DesignId]              INT           NOT NULL
    , [FabricationFacilityId] INT           NOT NULL
    , [TestFlowId]            INT           NULL
    , [ProbeConversionId]     INT           NULL
    , [EffectiveOn]           DATETIME2 (7) NULL
    CONSTRAINT [PK_AcBuildCriterias] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_AcBuildCriterias_IsPOR] ON [qan].[AcBuildCriterias] ([IsPOR])

GO

CREATE INDEX [IX_AcBuildCriterias_IsActive] ON [qan].[AcBuildCriterias] ([IsActive])

GO

CREATE INDEX [IX_AcBuildCriterias_StatusId] ON [qan].[AcBuildCriterias] ([StatusId])

GO

CREATE INDEX [IX_AcBuildCriterias_BuildCombinationId] ON [qan].[AcBuildCriterias] ([BuildCombinationId])

GO

CREATE INDEX [IX_AcBuildCriterias_DesignId] ON [qan].[AcBuildCriterias] ([DesignId])

GO

CREATE INDEX [IX_AcBuildCriterias_FabricationFacilityId] ON [qan].[AcBuildCriterias] ([FabricationFacilityId])

GO

CREATE INDEX [IX_AcBuildCriterias_TestFlowId] ON [qan].[AcBuildCriterias] ([TestFlowId])

GO

CREATE INDEX [IX_AcBuildCriterias_ProbeConversionId] ON [qan].[AcBuildCriterias] ([ProbeConversionId])

GO
