CREATE TYPE [qan].[IOsatQfImportCriterias] AS TABLE
(
      [Index]               INT            NOT NULL
    , [GroupIndex]          INT            NOT NULL
    , [SourceIndex]         INT            NOT NULL
    , [Name]                VARCHAR (4000)     NULL
    , [DeviceName]          VARCHAR (4000)     NULL
    , [PartNumberDecode]    VARCHAR (4000)     NULL
    , [ES]                  VARCHAR (4000)     NULL
    , PRIMARY KEY CLUSTERED  ([Index] ASC)
    , INDEX [IX_GroupIndex]  ([GroupIndex])
    , INDEX [IX_SourceIndex] ([SourceIndex])
);
