CREATE TABLE [qan].[OsatBuildCriteriaSetComments]
(
      [Id]                    BIGINT        IDENTITY (1, 1) NOT NULL
    , [BuildCriteriaSetId]    BIGINT        NOT NULL
    , [Text]                  VARCHAR(MAX)  NOT NULL
    , [CreatedBy]             VARCHAR (25)  NOT NULL
    , [CreatedOn]             DATETIME2 (7) CONSTRAINT [DF_OsatBuildCriteriaSetComments_CreatedOn] DEFAULT (getutcdate()) NOT NULL
    , [UpdatedBy]             VARCHAR (25)  NOT NULL
    , [UpdatedOn]             DATETIME2 (7) CONSTRAINT [DF_OsatBuildCriteriaSetComments_UpdatedOn] DEFAULT (getutcdate()) NOT NULL
    CONSTRAINT [PK_OsatBuildCriteriaSetComments] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_OsatBuildCriteriaSetComments_BuildCriteriaId] ON [qan].[OsatBuildCriteriaSetComments] ([BuildCriteriaSetId])
