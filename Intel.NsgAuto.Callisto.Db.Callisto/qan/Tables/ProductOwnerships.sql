CREATE TABLE [qan].[ProductOwnerships] (
    [Id]                       INT           IDENTITY (1, 1) NOT NULL,
    [ProductTypeId]            INT           NOT NULL,
    [ProductPlatformId]        INT           NOT NULL,
    [CodeNameId]               INT           NULL,
    [ProductClassification]    VARCHAR (25)  NULL,
    [ProductBrandNameId]       INT           NULL,
    [ProductLifeCycleStatusId] INT           NULL,
    [ProductLaunchDate]        DATE          NULL,
    [IsActive]                 BIT           CONSTRAINT [DF_ProductOwnerships_IsActive] DEFAULT ((1)) NULL,
    [CreatedBy]                VARCHAR (25)  NULL,
    [CreatedOn]                DATETIME2 (7) CONSTRAINT [DF_ProductOwnerships_CreatedOn] DEFAULT (getutcdate()) NULL,
    [UpdatedBy]                VARCHAR (25)  NULL,
    [UpdatedOn]                DATETIME2 (7) CONSTRAINT [DF_ProductOwnerships_UpdatedOn] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_ProductOwnerships] PRIMARY KEY CLUSTERED ([Id] ASC)
);







