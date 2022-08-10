CREATE TABLE [qan].[OdmQualFilters] (
    [Id]                      INT          IDENTITY (1, 1) NOT NULL,
    [ScenarioId]              INT          NOT NULL,
    [OdmId]                   INT          NOT NULL,
    [DesignId]                VARCHAR (10) NOT NULL,
    [SCode]                   VARCHAR (25) NOT NULL,
    [MediaIPN]                VARCHAR (25) NOT NULL,
    [SLot]                    VARCHAR (25) NOT NULL,
    [OdmQualFilterCategoryId] INT          NOT NULL,
    CONSTRAINT [PK_IOG_OdmQualFilters] PRIMARY KEY CLUSTERED ([Id] ASC)
);



