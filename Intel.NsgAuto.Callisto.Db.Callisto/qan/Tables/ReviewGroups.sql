CREATE TABLE [qan].[ReviewGroups] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [GroupName]   VARCHAR (50)  NOT NULL,
    [DisplayName] VARCHAR (100) NULL,
    [IsActive]    BIT           CONSTRAINT [DF_ReviewGroups_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedBy]   VARCHAR (25)  NOT NULL,
    [CreatedOn]   DATETIME2 (7) CONSTRAINT [DF_ReviewGroups_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]   VARCHAR (25)  NOT NULL,
    [UpdatedOn]   DATETIME2 (7) CONSTRAINT [DF_ReviewGroups_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_ReviewGroups] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_Reviewers_GroupName] UNIQUE NONCLUSTERED ([GroupName] ASC)
);
