CREATE TABLE [npsg].[OdmQualFilterAttemptedScenarios] (
    [AttemptedScenarioId]           INT            NOT NULL,
    [FailedReason]                  VARCHAR (4000) NULL,
    [AttemptedOn]                   DATETIME2 (7)  NOT NULL,
    [AttemptedBy]                   VARCHAR (255)  NOT NULL,
    [PrfVersion]                    INT            NULL,
    [MatVersion]                    INT            NULL,
    [OdmWipSnapshotVersion]         INT            NULL,
    [LotShipSnapshotVersion]        INT            NULL,
    [LotDispositionSnapshotVersion] INT            NULL,
    [ManualDispositionsVersion]     INT            NULL
);

