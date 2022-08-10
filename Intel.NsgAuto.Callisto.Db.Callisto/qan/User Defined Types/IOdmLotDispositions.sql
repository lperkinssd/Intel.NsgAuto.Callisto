CREATE TYPE [qan].[IOdmLotDispositions] AS TABLE (
    [Id]                     INT           NOT NULL,
    [ScenarioId]             INT           NOT NULL,
    [OdmQualFilterId]        INT           NOT NULL,
    [LotDispositionReasonId] INT           NOT NULL,
    [Notes]                  VARCHAR (MAX) NULL,
    [LotDispositionActionId] INT           NOT NULL);

