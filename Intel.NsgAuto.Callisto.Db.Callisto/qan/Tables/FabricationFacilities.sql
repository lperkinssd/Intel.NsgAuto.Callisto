CREATE TABLE [qan].[FabricationFacilities] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (50)  NOT NULL,
    [CreatedBy]    VARCHAR (25)  NOT NULL,
    [CreatedOn]    DATETIME2 (7) CONSTRAINT [DF_FabricationFacilities_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]    VARCHAR (25)  NOT NULL,
    [UpdatedOn]    DATETIME2 (7) CONSTRAINT [DF_FabricationFacilities_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_FabricationFacilities] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_FabricationFacilities_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
