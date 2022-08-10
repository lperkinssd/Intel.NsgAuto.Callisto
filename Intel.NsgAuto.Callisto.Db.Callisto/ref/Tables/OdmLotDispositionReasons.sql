CREATE TABLE [ref].[OdmLotDispositionReasons] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [Description] VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_OdmLotDispositionReasons] PRIMARY KEY CLUSTERED ([Id] ASC)
);

