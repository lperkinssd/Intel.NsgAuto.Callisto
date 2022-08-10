CREATE TABLE [qan].[OsatBuildCombinationOsats]
(
      [BuildCombinationId]  INT                 NOT NULL
    , [OsatId]              INT                 NOT NULL
    , [CreatedBy]           VARCHAR   (25)      NOT NULL
    , [CreatedOn]           DATETIME2 (7)       NOT NULL CONSTRAINT [DF_OsatBuildCombinationOsats_CreatedOn] DEFAULT (getutcdate())
    , [UpdatedBy]           VARCHAR   (25)      NOT NULL
    , [UpdatedOn]           DATETIME2 (7)       NOT NULL CONSTRAINT [DF_OsatBuildCombinationOsats_UpdatedOn] DEFAULT (getutcdate())
    , CONSTRAINT [PK_OsatBuildCombinationOsats] PRIMARY KEY CLUSTERED ([BuildCombinationId] ASC, [OsatId] ASC)
);
