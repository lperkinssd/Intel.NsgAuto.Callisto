CREATE TYPE [stage].[IOdmRemovableSLots] AS TABLE (
    [MMNum]          VARCHAR (255) NOT NULL,
    [DesignId]       VARCHAR (10)  NOT NULL,
    [MediaIPN]       VARCHAR (255) NOT NULL,
    [SLot]           VARCHAR (255) NOT NULL,
    [CreateDate]     DATETIME2 (7) NOT NULL,
    [IsRemovable]    VARCHAR (5)   NOT NULL,
    [OdmName]        VARCHAR (255) NOT NULL,
    [SourceFileName] VARCHAR (255) NOT NULL);

