CREATE TYPE [npsg].[IImportMessages] AS TABLE (
    [RecordNumber] INT           NOT NULL,
    [FieldName]    VARCHAR (50)  NULL,
    [MessageType]  VARCHAR (20)  NULL,
    [Message]      VARCHAR (256) NULL);

