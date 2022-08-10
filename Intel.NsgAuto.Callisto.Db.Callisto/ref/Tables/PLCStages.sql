﻿CREATE TABLE [ref].[PLCStages] (
    [Id]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (25) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_PLCStages_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


