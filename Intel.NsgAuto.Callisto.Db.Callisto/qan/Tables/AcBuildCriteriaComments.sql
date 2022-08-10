CREATE TABLE [qan].[AcBuildCriteriaComments]
(
      [Id]                    BIGINT        IDENTITY (1, 1) NOT NULL
    , [BuildCriteriaId]       BIGINT        NOT NULL
    , [Text]                  VARCHAR(MAX)  NOT NULL
    , [CreatedBy]             VARCHAR (25)  NOT NULL
    , [CreatedOn]             DATETIME2 (7) CONSTRAINT [DF_AcBuildCriteriaComments_CreatedOn] DEFAULT (getutcdate()) NOT NULL
    , [UpdatedBy]             VARCHAR (25)  NOT NULL
    , [UpdatedOn]             DATETIME2 (7) CONSTRAINT [DF_AcBuildCriteriaComments_UpdatedOn] DEFAULT (getutcdate()) NOT NULL
    CONSTRAINT [PK_AcBuildCriteriaComments] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_AcBuildCriteriaComments_BuildCriteriaId] ON [qan].[AcBuildCriteriaComments] ([BuildCriteriaId])
