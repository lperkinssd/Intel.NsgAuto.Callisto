CREATE TABLE [qan].[ProductContactRoles] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [RoleId]    INT           NOT NULL,
    [ContactId] INT           NULL,
    [IsActive]  BIT           CONSTRAINT [DFQAN_ProductContactRoles_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedBy] VARCHAR (25)  NOT NULL,
    [CreatedOn] DATETIME2 (7) CONSTRAINT [DFQAN_ProductContactRoles_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy] VARCHAR (25)  NOT NULL,
    [UpdatedOn] DATETIME2 (7) CONSTRAINT [DFQAN_ProductContactRoles_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PKQAN_ProductContactRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_ProductContactRoles_RoleId]
    ON [qan].[ProductContactRoles]([RoleId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProductContactRoles_ContactId]
    ON [qan].[ProductContactRoles]([ContactId] ASC);

