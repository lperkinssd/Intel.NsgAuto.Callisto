CREATE TABLE [qan].[OdmQualFilterLotDispositions] (
    [Id]                     INT           IDENTITY (1, 1) NOT NULL,
    [ScenarioId]             INT           NULL,
    [OdmQualFilterId]        INT           NOT NULL,
    [LotDispositionReasonId] INT           NOT NULL,
    [Notes]                  VARCHAR (MAX) NULL,
    [LotDispositionActionId] INT           NULL,
    [CreatedOn]              DATETIME2 (7) CONSTRAINT [DF_IOG_OdmQualFilterLotDispositions_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [CreatedBy]              VARCHAR (255) NOT NULL,
    [UpdatedOn]              DATETIME2 (7) CONSTRAINT [DF_IOG_OdmQualFilterLotDispositions_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]              VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_IOG_OdmQualFilterLotDispositions] PRIMARY KEY CLUSTERED ([Id] ASC)
);










GO
CREATE NONCLUSTERED INDEX [IX_IOG_OdmQualFilterId_OdmQualFilterLotDispositions]
    ON [qan].[OdmQualFilterLotDispositions]([OdmQualFilterId] ASC);

