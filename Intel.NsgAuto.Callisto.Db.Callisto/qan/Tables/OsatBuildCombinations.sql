CREATE TABLE [qan].[OsatBuildCombinations] (
    [Id]                    INT           IDENTITY (1, 1) NOT NULL,
    [IsActive]              BIT           CONSTRAINT [DF_OsatBuildCombinations_IsActive] DEFAULT ((1)) NOT NULL,
    [DesignId]              INT           NOT NULL,
    [Osatid]                INT           NULL,
    [PartUseTypeId]         INT           NOT NULL,
    [MaterialMasterField]   VARCHAR (10)  NOT NULL,
    [IntelLevel1PartNumber] VARCHAR (25)  NOT NULL,
    [IntelProdName]         VARCHAR (100) NOT NULL,
    [IntelMaterialPn]       VARCHAR (25)  NOT NULL,
    [AssyUpi]               VARCHAR (25)  NOT NULL,
    [DeviceName]            VARCHAR (25)  NOT NULL,
    [CreatedBy]             VARCHAR (25)  NOT NULL,
    [CreatedOn]             DATETIME2 (7) CONSTRAINT [DF_OsatBuildCombinations_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]             VARCHAR (25)  NOT NULL,
    [UpdatedOn]             DATETIME2 (7) CONSTRAINT [DF_OsatBuildCombinations_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    [Mpp]                   VARCHAR (10)  NULL,
    [PackageDieTypeId]      INT           NOT NULL,
    [PublishDisabledBy]     VARCHAR (25)  NULL,
    [PublishDisabledOn]     DATETIME2 (7) NULL,
    CONSTRAINT [PK_OsatBuildCombinations] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatBuildCombinations_DesignId_OsatId_MMNumber_IntelLevel1PartName_AssemblyUpi_DeviceName] UNIQUE NONCLUSTERED ([DesignId] ASC, [Osatid] ASC, [MaterialMasterField] ASC, [IntelLevel1PartNumber] ASC, [IntelProdName] ASC, [IntelMaterialPn] ASC, [AssyUpi] ASC, [DeviceName] ASC)
);





GO

CREATE INDEX [IX_OsatBuildCombinations_DesignId] ON [qan].[OsatBuildCombinations] ([DesignId])

GO

CREATE INDEX [IX_OsatBuildCombinations_PartUseTypeId] ON [qan].[OsatBuildCombinations] ([PartUseTypeId])

GO

CREATE INDEX [IX_OsatBuildCombinations_MaterialMasterField] ON [qan].[OsatBuildCombinations] ([MaterialMasterField])

GO

CREATE INDEX [IX_OsatBuildCombinations_IntelLevel1PartNumber] ON [qan].[OsatBuildCombinations] ([IntelLevel1PartNumber])

GO

CREATE INDEX [IX_OsatBuildCombinations_IntelProdName] ON [qan].[OsatBuildCombinations] ([IntelProdName])

GO

CREATE INDEX [IX_OsatBuildCombinations_IntelMaterialPn] ON [qan].[OsatBuildCombinations] ([IntelMaterialPn])

GO

CREATE INDEX [IX_OsatBuildCombinations_AssyUpi] ON [qan].[OsatBuildCombinations] ([AssyUpi])

GO

CREATE INDEX [IX_OsatBuildCombinations_DeviceName] ON [qan].[OsatBuildCombinations] ([DeviceName])

GO

CREATE INDEX [IX_OsatBuildCombinations_PackageDieTypeId] ON [qan].[OsatBuildCombinations] ([PackageDieTypeId])

GO

CREATE INDEX [IX_OsatBuildCombinations_PublishDisabledOn] ON [qan].[OsatBuildCombinations] ([PublishDisabledOn])