CREATE TABLE [qan].[Reviewers] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [Name]       VARCHAR (255) NOT NULL,
    [Idsid]      VARCHAR (50)  NOT NULL,
    [Wwid]       VARCHAR (10)  NOT NULL,
    [Email]      VARCHAR (255) NOT NULL,
    [IsActive]   BIT           CONSTRAINT [DF_Reviewers_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedBy]  VARCHAR (25)  NOT NULL,
    [CreatedOn]  DATETIME2 (7) CONSTRAINT [DF_Reviewers_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]  VARCHAR (25)  NOT NULL,
    [UpdatedOn]  DATETIME2 (7) CONSTRAINT [DF_Reviewers_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_Reviewers] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_Reviewers_Idsid] UNIQUE NONCLUSTERED ([Idsid] ASC),
    CONSTRAINT [U_Reviewers_Wwid] UNIQUE NONCLUSTERED ([Wwid] ASC),
    CONSTRAINT [U_Reviewers_Email] UNIQUE NONCLUSTERED ([Email] ASC)
);
