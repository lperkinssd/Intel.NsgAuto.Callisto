CREATE TABLE [npsg].[MATVersions] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [VersionNumber] INT           NOT NULL,
    [IsActive]      BIT           CONSTRAINT [DF_NPSG_MATVersions_IsActive] DEFAULT ((1)) NOT NULL,
    [StatusId]      INT           CONSTRAINT [DF_NPSG_MATVersions_StatusId] DEFAULT ((1)) NOT NULL,
    [IsPOR]         BIT           CONSTRAINT [DF_NPSG_MATVersions_IsPOR] DEFAULT ((0)) NOT NULL,
    [CreatedBy]     VARCHAR (25)  NULL,
    [CreatedOn]     DATETIME2 (7) CONSTRAINT [DF_NPSG_MATVersions_CreatedOn] DEFAULT (getutcdate()) NULL,
    [UpdatedBy]     VARCHAR (25)  NULL,
    [UpdatedOn]     DATETIME2 (7) CONSTRAINT [DF_NPSG_MATVersions_UpdatedOn] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_NPSG_MATVersions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

