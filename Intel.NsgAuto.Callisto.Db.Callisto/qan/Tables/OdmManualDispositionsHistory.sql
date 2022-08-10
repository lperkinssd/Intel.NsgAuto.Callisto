CREATE TABLE [qan].[OdmManualDispositionsHistory] (
    [Id]                     INT           NOT NULL,
    [Version]                INT           NOT NULL,
    [SLot]                   VARCHAR (25)  NOT NULL,
    [IntelPartNumber]        VARCHAR (25)  NOT NULL,
    [LotDispositionReasonId] INT           NOT NULL,
    [Notes]                  VARCHAR (MAX) NULL,
    [LotDispositionActionId] INT           NOT NULL,
    [CreatedOn]              DATETIME2 (7) NOT NULL,
    [CreatedBy]              VARCHAR (255) NOT NULL,
    [UpdatedOn]              DATETIME2 (7) NOT NULL,
    [UpdatedBy]              VARCHAR (255) NOT NULL,
    [ArchivedOn]             DATETIME2 (7) NULL,
    [ArchivedBy]             VARCHAR (255) NULL
);

