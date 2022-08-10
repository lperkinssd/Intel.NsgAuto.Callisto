CREATE TABLE [ref].[AcComparisonOperations] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [Key]            VARCHAR (25)  NOT NULL,
    [KeyTreadstone]  VARCHAR (20)  NOT NULL,
    [Name]           VARCHAR (50)  NOT NULL,
    [OperandTypeId]  INT           NOT NULL,
    CONSTRAINT [PK_AcComparisonOperations] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_AcComparisonOperations_Key] UNIQUE NONCLUSTERED ([Key] ASC),
    CONSTRAINT [U_AcComparisonOperations_KeyTreadstone] UNIQUE NONCLUSTERED ([KeyTreadstone] ASC),
    CONSTRAINT [U_AcComparisonOperations_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
