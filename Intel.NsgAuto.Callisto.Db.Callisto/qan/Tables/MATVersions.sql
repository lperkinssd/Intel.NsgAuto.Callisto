CREATE TABLE [qan].[MATVersions] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [VersionNumber] INT           NOT NULL,
    [IsActive]      BIT           CONSTRAINT [DF_MATVersions_IsActive] DEFAULT ((1)) NOT NULL,
    [StatusId]      INT           CONSTRAINT [DF_MATVersions_StatusId] DEFAULT ((1)) NOT NULL,
    [IsPOR]         BIT           CONSTRAINT [DF_MATVersions_IsPOR] DEFAULT ((0)) NOT NULL,
    [CreatedBy]     VARCHAR (25)  NULL,
    [CreatedOn]     DATETIME2 (7) CONSTRAINT [DF_MATVersions_CreatedOn] DEFAULT (getutcdate()) NULL,
    [UpdatedBy]     VARCHAR (25)  NULL,
    [UpdatedOn]     DATETIME2 (7) CONSTRAINT [DF_MATVersions_UpdatedOn] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_MATVersions] PRIMARY KEY CLUSTERED ([Id] ASC)
);



