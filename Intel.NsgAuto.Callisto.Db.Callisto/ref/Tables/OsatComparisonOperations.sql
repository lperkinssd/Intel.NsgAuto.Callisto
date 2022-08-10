CREATE TABLE [ref].[OsatComparisonOperations] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [Key]            VARCHAR (25)  NOT NULL,
    [Name]           VARCHAR (50)  NOT NULL,
    [OperandTypeId]  INT           NOT NULL,
    CONSTRAINT [PK_OsatComparisonOperations] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatComparisonOperations_Key] UNIQUE NONCLUSTERED ([Key] ASC),
    CONSTRAINT [U_OsatComparisonOperations_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
