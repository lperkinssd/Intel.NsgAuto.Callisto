CREATE TABLE [ref].[OpalTypes] (
    [Id]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (10) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OpalTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);





