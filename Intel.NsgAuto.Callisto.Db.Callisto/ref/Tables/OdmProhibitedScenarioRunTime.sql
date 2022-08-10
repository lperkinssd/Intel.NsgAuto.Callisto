CREATE TABLE [ref].[OdmProhibitedScenarioRunTime] (
    [Id]              INT           IDENTITY (1, 1) NOT NULL,
    [Process]         VARCHAR (10)  NOT NULL,
    [StartTime]       VARCHAR (15)  NOT NULL,
    [EndTime]         VARCHAR (15)  NOT NULL,
    [IsActive]        BIT           NOT NULL,
    [EffectiveDate]   DATETIME2 (7) NOT NULL,
    [DeactivatedDate] DATETIME2 (7) NULL,
    CONSTRAINT [PK_OdmProhibitedScenarioRunTime] PRIMARY KEY CLUSTERED ([Id] ASC)
);

