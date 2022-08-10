CREATE TYPE [qan].[IOsatQfImportAttributes] AS TABLE
(
      [Index]               INT            NOT NULL
    , [CriteriaIndex]       INT            NOT NULL
    , [Name]                VARCHAR (4000) NOT NULL
    , [Value]               VARCHAR (4000)     NULL
    , PRIMARY KEY CLUSTERED ([Index] ASC)
    , INDEX [IX_CriteriaIndex] ([CriteriaIndex])
);
