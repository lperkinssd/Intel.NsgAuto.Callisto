CREATE TABLE [qan].[OsatBuildCriteriaSets] (
      [Id]                    BIGINT        IDENTITY (1, 1) NOT NULL
    , [Version]               INT           NOT NULL
    , [IsPOR]                 BIT           CONSTRAINT [DF_OsatBuildCriteriaSets_IsPOR] DEFAULT (0) NOT NULL
    , [IsActive]              BIT           CONSTRAINT [DF_OsatBuildCriteriaSets_IsActive] DEFAULT (1) NOT NULL
    , [StatusId]              INT           NOT NULL
    , [CreatedBy]             VARCHAR (25)  NOT NULL
    , [CreatedOn]             DATETIME2 (7) CONSTRAINT [DF_OsatBuildCriteriaSets_CreatedOn] DEFAULT (getutcdate()) NOT NULL
    , [UpdatedBy]             VARCHAR (25)  NOT NULL
    , [UpdatedOn]             DATETIME2 (7) CONSTRAINT [DF_OsatBuildCriteriaSets_UpdatedOn] DEFAULT (getutcdate()) NOT NULL
    , [EffectiveOn]           DATETIME2 (7) NULL
    , [BuildCombinationId]    INT           NOT NULL
    CONSTRAINT [PK_OsatBuildCriteriaSets] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_OsatBuildCriteriaSets_IsPOR] ON [qan].[OsatBuildCriteriaSets] ([IsPOR])

GO

CREATE INDEX [IX_OsatBuildCriteriaSets_IsActive] ON [qan].[OsatBuildCriteriaSets] ([IsActive])

GO

CREATE INDEX [IX_OsatBuildCriteriaSets_StatusId] ON [qan].[OsatBuildCriteriaSets] ([StatusId])

GO

CREATE INDEX [IX_OsatBuildCriteriaSets_BuildCombinationId] ON [qan].[OsatBuildCriteriaSets] ([BuildCombinationId])

GO
