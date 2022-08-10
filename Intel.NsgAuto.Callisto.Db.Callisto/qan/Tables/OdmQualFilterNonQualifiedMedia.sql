CREATE TABLE [qan].[OdmQualFilterNonQualifiedMedia] (
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    [ScenarioId]    INT          NOT NULL,
    [DesignId]      VARCHAR (10) NULL,
    [OdmId]         INT          NOT NULL,
    [SCodeMMNumber] VARCHAR (25) NOT NULL,
    [MediaIPN]      VARCHAR (25) NOT NULL,
    [SLot]          VARCHAR (25) NOT NULL,
    CONSTRAINT [PK_OdmQualFilterNonQualifiedMedia] PRIMARY KEY CLUSTERED ([Id] ASC)
);



