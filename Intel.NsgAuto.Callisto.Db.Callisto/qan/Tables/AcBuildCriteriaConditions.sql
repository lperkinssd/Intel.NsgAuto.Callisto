CREATE TABLE [qan].[AcBuildCriteriaConditions]
(
      [Id]                    BIGINT        IDENTITY (1, 1) NOT NULL
    , [BuildCriteriaId]       BIGINT        NOT NULL
    , [AttributeTypeId]       INT           NOT NULL
    , [ComparisonOperationId] INT           NOT NULL
    , [Value]                 VARCHAR(4000) COLLATE SQL_Latin1_General_CP1_CS_AS NULL
    , [CreatedBy]             VARCHAR (25)  NOT NULL
    , [CreatedOn]             DATETIME2 (7) CONSTRAINT [DF_AcBuildCriteriaConditions_CreatedOn] DEFAULT (getutcdate()) NOT NULL
    , [UpdatedBy]             VARCHAR (25)  NOT NULL
    , [UpdatedOn]             DATETIME2 (7) CONSTRAINT [DF_AcBuildCriteriaConditions_UpdatedOn] DEFAULT (getutcdate()) NOT NULL
    CONSTRAINT [PK_AcBuildCriteriaConditions] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_AcBuildCriteriaConditions_BuildCriteriaId_AttributeTypeId_ComparisonOperationId] UNIQUE NONCLUSTERED ([BuildCriteriaId] ASC, [AttributeTypeId] ASC, [ComparisonOperationId] ASC),
);

GO

CREATE INDEX [IX_AcBuildCriteriaConditions_BuildCriteriaId] ON [qan].[AcBuildCriteriaConditions] ([BuildCriteriaId])

GO

CREATE INDEX [IX_AcBuildCriteriaConditions_AttributeTypeId] ON [qan].[AcBuildCriteriaConditions] ([AttributeTypeId])

GO

CREATE INDEX [IX_AcBuildCriteriaConditions_ComparisonOperationId] ON [qan].[AcBuildCriteriaConditions] ([ComparisonOperationId])

GO
