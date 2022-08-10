CREATE TABLE [npsg].[OdmQualFilterNonQualifiedMediaReport] (
    [ScenarioId] INT            NOT NULL,
    [MMNum]      VARCHAR (50)   NULL,
    [OdmName]    VARCHAR (50)   NULL,
    [DesignId]   VARCHAR (50)   NULL,
    [SLots]      NVARCHAR (MAX) NULL,
    [MatId]      INT            NULL,
    [PrfId]      INT            NULL,
    [OsatIpn]    VARCHAR (50)   NULL,
    [CreatedBy]  VARCHAR (50)   NULL,
    [CreatedOn]  DATETIME       NULL
);

