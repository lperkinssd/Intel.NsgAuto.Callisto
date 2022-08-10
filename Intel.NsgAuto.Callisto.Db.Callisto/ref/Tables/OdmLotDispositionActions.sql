CREATE TABLE [ref].[OdmLotDispositionActions] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [ActionName]  VARCHAR (255) NOT NULL,
    [DisplayText] VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_OdmLotDispositionActions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

