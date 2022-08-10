CREATE TYPE [qan].[IOsatQfImportGroupFields] AS TABLE
(
      [Index]               INT            NOT NULL
    , [GroupIndex]          INT            NOT NULL
    , [SourceIndex]         INT            NOT NULL
    , [Name]                VARCHAR (4000)     NULL
    , [SourceName]          VARCHAR (4000)     NULL
    , [IsAttribute]         BIT            NOT NULL
    , PRIMARY KEY CLUSTERED ([Index] ASC)
    , INDEX [IX_SourceIndex] ([SourceIndex])
    , INDEX [IX_GroupIndex] ([GroupIndex])
);
