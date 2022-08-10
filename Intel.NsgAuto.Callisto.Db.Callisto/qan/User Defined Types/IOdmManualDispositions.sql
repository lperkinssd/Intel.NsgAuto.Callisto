CREATE TYPE [qan].[IOdmManualDispositions] AS TABLE (
    [SLot]                   VARCHAR (25)  NOT NULL,
    [IntelPartNumber]        VARCHAR (25)  NOT NULL,
    [LotDispositionReasonId] INT           NOT NULL,
    [Notes]                  VARCHAR (MAX) NULL,
    [LotDispositionActionId] INT           NOT NULL);



