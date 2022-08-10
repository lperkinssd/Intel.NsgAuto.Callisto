CREATE TABLE [qan].[OsatPasVersionRecords] (
    [Id]                          BIGINT        IDENTITY (1, 1) NOT NULL,
    [VersionId]                   INT           NOT NULL,
    [RecordNumber]                INT           NOT NULL,
    [ProductGroup]                VARCHAR (100) NULL,
    [Project]                     VARCHAR (25)  NULL,
    [IntelProdName]               VARCHAR (100) NULL,
    [IntelLevel1PartNumber]       VARCHAR (25)  NULL,
    [Line1TopSideMarking]         VARCHAR (200) NULL,
    [CopyrightYear]               VARCHAR (10)  NULL,
    [SpecNumberField]             VARCHAR (10)  NULL,
    [MaterialMasterField]         VARCHAR (10)  NULL,
    [MaxQtyPerMedia]              VARCHAR (25)  NULL,
    [Media]                       VARCHAR (10)  NULL,
    [RoHsCompliant]               VARCHAR (5)   NULL,
    [LotNo]                       VARCHAR (5)   NULL,
    [FullMediaReqd]               VARCHAR (5)   NULL,
    [SupplierPartNumber]          VARCHAR (10)  NULL,
    [IntelMaterialPn]             VARCHAR (25)  NULL,
    [TestUpi]                     VARCHAR (25)  NULL,
    [PgTierAndSpeedInfo]          VARCHAR (100) NULL,
    [AssyUpi]                     VARCHAR (25)  NULL,
    [DeviceName]                  VARCHAR (25)  NULL,
    [Mpp]                         VARCHAR (10)  NULL,
    [SortUpi]                     VARCHAR (25)  NULL,
    [ReclaimUpi]                  VARCHAR (25)  NULL,
    [ReclaimMm]                   VARCHAR (25)  NULL,
    [ProductNaming]               VARCHAR (25)  NULL,
    [TwoDidApproved]              VARCHAR (25)  NULL,
    [TwoDidStartedWw]             VARCHAR (25)  NULL,
    [Did]                         VARCHAR (10)  NULL,
    [Group]                       VARCHAR (25)  NULL,
    [Note]                        VARCHAR (500) NULL,
    CONSTRAINT [PK_OsatPasVersionRecords] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatPasVersionRecords_VersionId_RecordNumber] UNIQUE NONCLUSTERED ([VersionId] ASC, [RecordNumber] ASC)
);

GO

CREATE INDEX [IX_OsatPasVersionRecords_VersionId] ON [qan].[OsatPasVersionRecords] ([VersionId])

GO

CREATE INDEX [IX_OsatPasVersionRecords_RecordNumber] ON [qan].[OsatPasVersionRecords] ([RecordNumber])

GO

CREATE INDEX [IX_OsatPasVersionRecords_Project] ON [qan].[OsatPasVersionRecords] ([Project])

GO

CREATE INDEX [IX_OsatPasVersionRecords_IntelProdName] ON [qan].[OsatPasVersionRecords] ([IntelProdName])

GO

CREATE INDEX [IX_OsatPasVersionRecords_IntelLevel1PartNumber] ON [qan].[OsatPasVersionRecords] ([IntelLevel1PartNumber])

GO

CREATE INDEX [IX_OsatPasVersionRecords_MaterialMasterField] ON [qan].[OsatPasVersionRecords] ([MaterialMasterField])

GO

CREATE INDEX [IX_OsatPasVersionRecords_IntelMaterialPn] ON [qan].[OsatPasVersionRecords] ([IntelMaterialPn])

GO

CREATE INDEX [IX_OsatPasVersionRecords_TestUpi] ON [qan].[OsatPasVersionRecords] ([TestUpi])

GO

CREATE INDEX [IX_OsatPasVersionRecords_AssyUpi] ON [qan].[OsatPasVersionRecords] ([AssyUpi])

GO

CREATE INDEX [IX_OsatPasVersionRecords_DeviceName] ON [qan].[OsatPasVersionRecords] ([DeviceName])

GO

CREATE INDEX [IX_OsatPasVersionRecords_Did] ON [qan].[OsatPasVersionRecords] ([Did])

GO

CREATE INDEX [IX_OsatPasVersionRecords_Group] ON [qan].[OsatPasVersionRecords] ([Group])
