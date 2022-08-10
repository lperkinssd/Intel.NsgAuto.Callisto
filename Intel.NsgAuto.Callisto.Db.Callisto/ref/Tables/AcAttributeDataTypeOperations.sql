CREATE TABLE [ref].[AcAttributeDataTypeOperations] (
    [AttributeDataTypeId]    INT           NOT NULL,
    [ComparisonOperationId]  INT           NOT NULL,
    CONSTRAINT [PK_AcAttributeDataTypeOperations] PRIMARY KEY CLUSTERED ([AttributeDataTypeId] ASC, [ComparisonOperationId] ASC),
);
