CREATE TABLE [qan].[OsatBuildCriteriaSetBulkUpdateImportRecords] (
    [Id]                    BIGINT         IDENTITY (1, 1) NOT NULL,
    [ImportId]              INT            NOT NULL,
    [BuildCriteriaSetId]    INT            NOT NULL,
    [BuildCombinationId]    INT            NOT NULL,
    [Version]               INT            NOT NULL,
    [FileVersion]           INT            NULL,
    [DesignId]              INT            NULL,
    [OsatId]                INT            NULL,
    [DesignFamilyId]        INT            NULL,
    [DeviceName]            VARCHAR (28)   NULL,
    [PartNumberDecode]      VARCHAR (100)  NULL,
    [IntelLevel1PartNumber] VARCHAR (25)   NULL,
    [IntelProdName]         VARCHAR (100)  NULL,
    [Attribute]             VARCHAR (100)  NULL,
    [NewValue]              VARCHAR (4000) NULL,
    [OldValue]              VARCHAR (4000) NULL,
    [BuildCriteriaOrdinal]  INT            NULL,
    CONSTRAINT [PK_OsatBuildCriteriaSetBulkUpdateImportRecords] PRIMARY KEY CLUSTERED ([Id] ASC)
);



