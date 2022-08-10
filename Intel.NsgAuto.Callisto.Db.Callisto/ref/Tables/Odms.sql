CREATE TABLE [ref].[Odms] (
    [Id]   INT           IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_Odms_1] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_REF_Odms_Name]
    ON [ref].[Odms]([Name] ASC);

