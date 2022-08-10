CREATE TABLE [ref].[ReviewTypes] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [Description] VARCHAR (50)  NOT NULL,
    [IsActive]    BIT           CONSTRAINT [DF_ReviewTypes_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedBy]   VARCHAR (255) NOT NULL,
    [CreatedOn]   DATETIME2 (7) CONSTRAINT [DF_ReviewTypes_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]   VARCHAR (255) NOT NULL,
    [UpdatedOn]   DATETIME2 (7) CONSTRAINT [DF_ReviewTypes_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ReviewTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_ReviewTypes_Description] UNIQUE NONCLUSTERED ([Description] ASC)
);
