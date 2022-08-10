CREATE TABLE [ref].[MixTypes] (
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (50) NOT NULL,
    [Abbreviation]  VARCHAR (5)  NOT NULL,
    CONSTRAINT [PK_MixTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_MixTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC),
    CONSTRAINT [U_MixTypes_Abbreviation] UNIQUE NONCLUSTERED ([Abbreviation] ASC)
);
