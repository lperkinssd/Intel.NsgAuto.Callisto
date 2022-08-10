CREATE TABLE [qan].[Products] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (10)  NOT NULL,
    [DesignFamilyId] INT           NOT NULL,
    [IsActive]       BIT           CONSTRAINT [DF_Products_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedBy]      VARCHAR (25)  NOT NULL,
    [CreatedOn]      DATETIME2 (7) CONSTRAINT [DF_Products_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]      VARCHAR (25)  NOT NULL,
    [UpdatedOn]      DATETIME2 (7) CONSTRAINT [DF_Products_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    [MixTypeId]      INT           NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_Products_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
