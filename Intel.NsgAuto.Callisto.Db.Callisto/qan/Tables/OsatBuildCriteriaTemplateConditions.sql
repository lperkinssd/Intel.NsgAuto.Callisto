CREATE TABLE [qan].[OsatBuildCriteriaTemplateConditions]
(
      [Id]                    INT            IDENTITY (1, 1) NOT NULL
    , [TemplateId]            INT            NOT NULL
    , [AttributeTypeId]       INT            NOT NULL
    , [ComparisonOperationId] INT            NOT NULL
    , [Value]                 VARCHAR(4000)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL
      CONSTRAINT [PK_OsatBuildCriteriaTemplateConditions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_OsatBuildCriteriaTemplateConditions_TemplateId] ON [qan].[OsatBuildCriteriaTemplateConditions] ([TemplateId])

GO

CREATE INDEX [IX_OsatBuildCriteriaTemplateConditions_AttributeTypeId] ON [qan].[OsatBuildCriteriaTemplateConditions] ([AttributeTypeId])

GO

CREATE INDEX [IX_OsatBuildCriteriaTemplateConditions_ComparisonOperationId] ON [qan].[OsatBuildCriteriaTemplateConditions] ([ComparisonOperationId])

GO
