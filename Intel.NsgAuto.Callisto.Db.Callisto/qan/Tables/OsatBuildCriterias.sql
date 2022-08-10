CREATE TABLE [qan].[OsatBuildCriterias]
(
      [Id]                    BIGINT        IDENTITY (1, 1) NOT NULL
    , [BuildCriteriaSetId]    BIGINT        NOT NULL
    , [Ordinal]               INT           NOT NULL
    , [Name]                  VARCHAR (50)  NOT NULL
    , [CreatedBy]             VARCHAR (25)  NOT NULL
    , [CreatedOn]             DATETIME2 (7) CONSTRAINT [DF_OsatBuildCriterias_CreatedOn] DEFAULT (getutcdate()) NOT NULL
    , [UpdatedBy]             VARCHAR (25)  NOT NULL
    , [UpdatedOn]             DATETIME2 (7) CONSTRAINT [DF_OsatBuildCriterias_UpdatedOn] DEFAULT (getutcdate()) NOT NULL
      CONSTRAINT [PK_OsatBuildCriterias] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_OsatBuildCriterias_BuildCriteriaSetId_Ordinal] UNIQUE NONCLUSTERED ([BuildCriteriaSetId] ASC, [Ordinal] ASC)
    , CONSTRAINT [U_OsatBuildCriterias_BuildCriteriaSetId_Name] UNIQUE NONCLUSTERED ([BuildCriteriaSetId] ASC, [Name] ASC)
)

GO

CREATE INDEX [IX_OsatBuildCriterias_BuildCriteriaSetId] ON [qan].[OsatBuildCriterias] ([BuildCriteriaSetId])

GO

CREATE INDEX [IX_OsatBuildCriterias_Ordinal] ON [qan].[OsatBuildCriterias] ([Ordinal])
