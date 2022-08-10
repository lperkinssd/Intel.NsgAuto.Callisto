CREATE TYPE [qan].[IOsatQfImportGroups] AS TABLE
(
      [Index]               INT            NOT NULL
    , [SourceIndex]         INT            NOT NULL
    , [Name]                VARCHAR (4000)     NULL
    , PRIMARY KEY CLUSTERED ([Index] ASC)
    , INDEX [IX_SourceIndex] ([SourceIndex])
);
