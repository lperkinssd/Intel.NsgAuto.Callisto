﻿CREATE TABLE [ref].[OdmQualFilterStatuses] (
    [Id]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_OdmQualFilterStatuses] PRIMARY KEY CLUSTERED ([Id] ASC)
);
