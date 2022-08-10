CREATE TABLE [ref].[AcOperandTypes] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_AcOperandTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_AcOperandTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
