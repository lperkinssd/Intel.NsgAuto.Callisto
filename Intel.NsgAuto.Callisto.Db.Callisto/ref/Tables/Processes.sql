CREATE TABLE [ref].[Processes] (
    [Name]      VARCHAR (10)  NOT NULL,
    [IsActive]  BIT           NOT NULL,
    [CreatedBy] VARCHAR (255) NOT NULL,
    [CreatedOn] DATETIME2 (7) NOT NULL,
    [UpdatedBy] VARCHAR (255) NOT NULL,
    [UpdatedOn] DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_Processes] PRIMARY KEY CLUSTERED ([Name] ASC) WITH (FILLFACTOR = 90)
);



