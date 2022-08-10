CREATE TABLE [qan].[MATs] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [MATVersionId] INT           NOT NULL,
    [SSDNameId]    INT           NOT NULL,
    [ProductId]    INT           NOT NULL,
    [SCode]        VARCHAR (50)  NOT NULL,
    [MediaIPN]     VARCHAR (50)  NOT NULL,
    [MediaType]    VARCHAR (50)  NOT NULL,
    [DeviceName]   VARCHAR (50)  NOT NULL,
    [CreatedBy]    VARCHAR (25)  NULL,
    [CreatedOn]    DATETIME2 (7) CONSTRAINT [DF_MATs_CreatedOn] DEFAULT (getutcdate()) NULL,
    [UpdatedBy]    VARCHAR (25)  NULL,
    [UpdatedOn]    DATETIME2 (7) CONSTRAINT [DF_MATs_UpdatedOn] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_MATs] PRIMARY KEY CLUSTERED ([Id] ASC)
);

