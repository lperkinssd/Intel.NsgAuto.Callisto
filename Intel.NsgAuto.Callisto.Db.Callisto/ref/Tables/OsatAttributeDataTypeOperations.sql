CREATE TABLE [ref].[OsatAttributeDataTypeOperations] (
    [AttributeDataTypeId]    INT           NOT NULL,
    [ComparisonOperationId]  INT           NOT NULL,
    CONSTRAINT [PK_OsatAttributeDataTypeOperations] PRIMARY KEY CLUSTERED ([AttributeDataTypeId] ASC, [ComparisonOperationId] ASC),
);
