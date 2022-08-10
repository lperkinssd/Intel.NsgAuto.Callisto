CREATE TABLE [npsg].[OdmNameMappings] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [OdmDescription] VARCHAR (255) NOT NULL,
    [MappedOdmId]    INT           NOT NULL,
    CONSTRAINT [PK_NPSG_OdmNameMappings] PRIMARY KEY CLUSTERED ([Id] ASC)
);

