CREATE TABLE [stage].[OdmNPSGRemovableSLotsHistory] (
    [Version]        INT           NOT NULL,
    [MMNum]          VARCHAR (255) NOT NULL,
    [DesignId]       VARCHAR (10)  NOT NULL,
    [MediaIPN]       VARCHAR (255) NOT NULL,
    [SLot]           VARCHAR (255) NOT NULL,
    [CreateDate]     DATETIME2 (7) NOT NULL,
    [IsRemovable]    VARCHAR (5)   NOT NULL,
    [OdmName]        VARCHAR (255) NOT NULL,
    [SourceFileName] VARCHAR (255) NOT NULL,
    [ReportedOn]     DATETIME2 (7) CONSTRAINT [DF_OdmNPSGRemovableSLotsHistory_ReportedOn] DEFAULT (getutcdate()) NOT NULL,
    [ReportedBy]     VARCHAR (255) NOT NULL,
    [ArchivedOn]     DATETIME2 (7) CONSTRAINT [DF_OdmNPSGRemovableSLotsHistory_ArchivedOn] DEFAULT (getutcdate()) NOT NULL,
    [ArchivedBy]     VARCHAR (255) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_OdmNPSGRemovableSLotsHistory]
    ON [stage].[OdmNPSGRemovableSLotsHistory]([Version] DESC);

