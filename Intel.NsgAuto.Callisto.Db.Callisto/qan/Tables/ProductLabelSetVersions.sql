CREATE TABLE [qan].[ProductLabelSetVersions] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Version]   INT           NOT NULL,
    [IsActive]  BIT           CONSTRAINT [DF_ProductLabelSetVersions_IsActive] DEFAULT ((1)) NOT NULL,
    [IsPOR]     BIT           CONSTRAINT [DF_ProductLabelSetVersions_IsPOR] DEFAULT ((0)) NOT NULL,
    [StatusId]  INT           NOT NULL,
    [CreatedBy] VARCHAR (25)  NOT NULL,
    [CreatedOn] DATETIME2 (7) CONSTRAINT [DF_ProductLabelSetVersions_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy] VARCHAR (25)  NOT NULL,
    [UpdatedOn] DATETIME2 (7) CONSTRAINT [DF_ProductLabelSetVersions_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ProductLabelSetVersions] PRIMARY KEY CLUSTERED ([Id] ASC)
);



GO



GO



GO


