CREATE TABLE [qan].[ProductCompatibleParts] (
    [ProductId] INT           NOT NULL,
    [PartId]    INT           NOT NULL,
    [CreatedBy] VARCHAR (25)  NULL,
    [CreatedOn] DATETIME2 (7) CONSTRAINT [DF_ProductCompatibleParts_CreatedOn] DEFAULT (getutcdate()) NULL
);




GO



GO


