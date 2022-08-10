CREATE TABLE [qan].[OsatBuildCriteriaConditions] (
    [Id]                    BIGINT         IDENTITY (1, 1) NOT NULL,
    [BuildCriteriaId]       BIGINT         NOT NULL,
    [AttributeTypeId]       INT            NOT NULL,
    [ComparisonOperationId] INT            NOT NULL,
    [Value]                 VARCHAR (4000) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [CreatedBy]             VARCHAR (25)   NOT NULL,
    [CreatedOn]             DATETIME2 (7)  CONSTRAINT [DF_OsatBuildCriteriaConditions_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]             VARCHAR (25)   NOT NULL,
    [UpdatedOn]             DATETIME2 (7)  CONSTRAINT [DF_OsatBuildCriteriaConditions_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    [BulkUpdated]           BIT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_OsatBuildCriteriaConditions] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatBuildCriteriaConditions_BuildCriteriaId_AttributeTypeId_ComparisonOperationId] UNIQUE NONCLUSTERED ([BuildCriteriaId] ASC, [AttributeTypeId] ASC, [ComparisonOperationId] ASC)
);



GO

CREATE INDEX [IX_OsatBuildCriteriaConditions_BuildCriteriaId] ON [qan].[OsatBuildCriteriaConditions] ([BuildCriteriaId])

GO

CREATE INDEX [IX_OsatBuildCriteriaConditions_AttributeTypeId] ON [qan].[OsatBuildCriteriaConditions] ([AttributeTypeId])

GO

CREATE INDEX [IX_OsatBuildCriteriaConditions_ComparisonOperationId] ON [qan].[OsatBuildCriteriaConditions] ([ComparisonOperationId])

GO
