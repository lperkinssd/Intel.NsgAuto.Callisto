CREATE TABLE [qan].[OdmQualFilterScenarios] (
    [Id]                            INT           IDENTITY (1, 1) NOT NULL,
    [PrfVersion]                    INT           NOT NULL,
    [MatVersion]                    INT           NOT NULL,
    [OdmWipSnapshotVersion]         INT           NULL,
    [LotShipSnapshotVersion]        INT           NULL,
    [LotDispositionSnapshotVersion] INT           NULL,
    [ManualDispositionsVersion]     INT           NULL,
    [CreatedOn]                     DATETIME2 (7) CONSTRAINT [DF_OdmQualFilterScenarios_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [CreatedBy]                     VARCHAR (255) NOT NULL,
    [DailyId]                       INT           NOT NULL,
    [StatusId]                      INT           NULL,
    CONSTRAINT [PK_OdmQualFilterScenarios] PRIMARY KEY CLUSTERED ([Id] ASC)
);









