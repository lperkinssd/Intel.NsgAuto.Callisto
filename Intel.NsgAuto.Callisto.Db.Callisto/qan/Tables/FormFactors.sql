CREATE TABLE [qan].[FormFactors] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (25)  NOT NULL,
    [NameSpeed] VARCHAR (20)  NULL,
    [CreatedBy] VARCHAR (25)  NOT NULL,
    [CreatedOn] DATETIME2 (7) CONSTRAINT [DF_FormFactors_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy] VARCHAR (25)  NOT NULL,
    [UpdatedOn] DATETIME2 (7) CONSTRAINT [DF_FormFactors_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_FormFactors] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_FormFactors_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);

GO

CREATE INDEX [IX_FormFactors_NameSpeed] ON [qan].[FormFactors] ([NameSpeed]);
