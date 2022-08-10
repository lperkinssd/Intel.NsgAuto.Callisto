CREATE TABLE [qan].[OdmQualFiltersHistory] (
    [Id]                      INT           NOT NULL,
    [ScenarioId]              INT           NOT NULL,
    [OdmId]                   INT           NOT NULL,
    [DesignId]                VARCHAR (10)  NOT NULL,
    [SCode]                   VARCHAR (25)  NOT NULL,
    [MediaIPN]                VARCHAR (25)  NOT NULL,
    [SLot]                    VARCHAR (25)  NOT NULL,
    [OdmQualFilterCategoryId] INT           NOT NULL,
    [ArchivedOn]              DATETIME2 (7) NOT NULL,
    [ArchivedBy]              VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_OdmQualFiltersHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

