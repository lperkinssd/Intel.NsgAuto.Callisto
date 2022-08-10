CREATE TABLE [qan].[AcBuildCriteriaTemplateConditions]
(
      [Id]                    INT            IDENTITY (1, 1) NOT NULL
    , [TemplateId]            INT            NOT NULL
    , [AttributeTypeId]       INT            NOT NULL
    , [ComparisonOperationId] INT            NOT NULL
    , [Value]                 VARCHAR(4000)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL
      CONSTRAINT [PK_AcBuildCriteriaTemplateConditions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE INDEX [IX_AcBuildCriteriaTemplateConditions_TemplateId] ON [qan].[AcBuildCriteriaTemplateConditions] ([TemplateId])

GO

CREATE INDEX [IX_AcBuildCriteriaTemplateConditions_AttributeTypeId] ON [qan].[AcBuildCriteriaTemplateConditions] ([AttributeTypeId])

GO

CREATE INDEX [IX_AcBuildCriteriaTemplateConditions_ComparisonOperationId] ON [qan].[AcBuildCriteriaTemplateConditions] ([ComparisonOperationId])

GO
