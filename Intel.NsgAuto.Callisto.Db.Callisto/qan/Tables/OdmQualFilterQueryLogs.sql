CREATE TABLE [qan].[OdmQualFilterQueryLogs] (
    [OdmQualFilterId] INT           NOT NULL,
    [Query]           VARCHAR (MAX) NULL,
    CONSTRAINT [PK_OdmQualFilterQueryLogs] PRIMARY KEY CLUSTERED ([OdmQualFilterId] ASC)
);

