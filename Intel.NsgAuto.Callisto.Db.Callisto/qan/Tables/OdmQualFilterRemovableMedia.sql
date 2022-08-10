CREATE TABLE [qan].[OdmQualFilterRemovableMedia] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [RemovableVersion] INT           NOT NULL,
    [OdmId]            INT           NOT NULL,
    [MMNum]            VARCHAR (255) NOT NULL,
    [DesignId]         VARCHAR (10)  NOT NULL,
    [MediaIPN]         VARCHAR (255) NOT NULL,
    [SLot]             VARCHAR (255) NOT NULL,
    [OdmCreateDate]    DATETIME2 (7) NOT NULL,
    [ReportedOn]       DATETIME2 (7) NOT NULL,
    [ReportedBy]       VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_QAN_OdmQualFilterRemovableMedia] PRIMARY KEY CLUSTERED ([Id] ASC)
);

