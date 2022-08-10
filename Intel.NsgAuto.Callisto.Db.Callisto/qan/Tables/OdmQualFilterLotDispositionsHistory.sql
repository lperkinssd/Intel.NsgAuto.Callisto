CREATE TABLE [qan].[OdmQualFilterLotDispositionsHistory] (
    [Id]                     INT           NOT NULL,
    [ScenarioId]             INT           NULL,
    [OdmQualFilterId]        INT           NOT NULL,
    [LotDispositionReasonId] INT           NOT NULL,
    [Notes]                  VARCHAR (MAX) NULL,
    [LotDispositionActionId] INT           NULL,
    [CreatedOn]              DATETIME2 (7) CONSTRAINT [DF_OdmQualFilterLotDispositionsHistory_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [CreatedBy]              VARCHAR (255) NOT NULL,
    [UpdatedOn]              DATETIME2 (7) CONSTRAINT [DF_OdmQualFilterLotDispositionsHistory_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]              VARCHAR (255) NOT NULL,
    [ArchivedOn]             DATETIME2 (7) NOT NULL,
    [ArchivedBy]             VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_OdmQualFilterLotDispositionsHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_OdmQualFilterId_OdmQualFilterLotDispositionsHistory]
    ON [qan].[OdmQualFilterLotDispositionsHistory]([OdmQualFilterId] ASC);

