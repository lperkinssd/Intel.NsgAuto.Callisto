CREATE TABLE [qan].[OsatQualFilterImports] (
    [Id]                        INT           IDENTITY (1, 1) NOT NULL,
    [CreatedBy]                 VARCHAR (25)  NOT NULL,
    [CreatedOn]                 DATETIME2 (7) CONSTRAINT [DF_OsatQualFilterImports_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]                 VARCHAR (25)  NOT NULL,
    [UpdatedOn]                 DATETIME2 (7) CONSTRAINT [DF_OsatQualFilterImports_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    [FileName]                  VARCHAR (250) NULL,
    [FileLengthInBytes]         INT           NULL,
    [MessageErrorsExist]        BIT           CONSTRAINT [DF_OsatQualFilterImports_MessageErrorsExist] DEFAULT ((0)) NOT NULL,
    [AllowBuildCriteriaActions] BIT           CONSTRAINT [DF_OsatQualFilterImports_AllowBuildCriteriaActions] DEFAULT ((1)) NOT NULL,
    [DesignId]                  INT           NOT NULL,
    CONSTRAINT [PK_OsatQualFilterImports] PRIMARY KEY CLUSTERED ([Id] ASC)
);



GO

CREATE INDEX [IX_OsatQualFilterImports_DesignId] ON [qan].[OsatQualFilterImports] ([DesignId])
